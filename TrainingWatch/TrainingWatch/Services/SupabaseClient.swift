import Foundation

class SupabaseClient {
    static let shared = SupabaseClient()

    let baseURL = "https://azgraotogacudqpuahrz.supabase.co"
    let anonKey = "sb_publishable_RoeDClj0q0LC6T4A3AGkmQ_rWjYtvDk"

    private var authToken: String? {
        KeychainHelper.get("pt_access_token")
    }

    private var refreshToken: String? {
        KeychainHelper.get("pt_refresh_token")
    }

    // MARK: - Auth

    func signIn(email: String, password: String) async throws -> AuthResponse {
        let url = URL(string: "\(baseURL)/auth/v1/token?grant_type=password")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(anonKey, forHTTPHeaderField: "apikey")
        req.httpBody = try JSONEncoder().encode(["email": email, "password": password])

        let (data, _) = try await URLSession.shared.data(for: req)
        let auth = try JSONDecoder().decode(AuthResponse.self, from: data)

        KeychainHelper.set("pt_access_token", value: auth.access_token)
        KeychainHelper.set("pt_refresh_token", value: auth.refresh_token)
        KeychainHelper.set("pt_user_id", value: auth.user.id)
        return auth
    }

    func doRefreshToken() async throws {
        guard let rt = refreshToken else { throw APIError.noToken }
        let url = URL(string: "\(baseURL)/auth/v1/token?grant_type=refresh_token")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(anonKey, forHTTPHeaderField: "apikey")
        req.httpBody = try JSONEncoder().encode(["refresh_token": rt])

        let (data, _) = try await URLSession.shared.data(for: req)
        let auth = try JSONDecoder().decode(AuthResponse.self, from: data)
        KeychainHelper.set("pt_access_token", value: auth.access_token)
        KeychainHelper.set("pt_refresh_token", value: auth.refresh_token)
    }

    // MARK: - REST

    func fetch<T: Decodable>(_ table: String, query: String = "") async throws -> [T] {
        let urlStr = "\(baseURL)/rest/v1/\(table)?\(query)"
        let data = try await request(urlStr, method: "GET")
        return try JSONDecoder().decode([T].self, from: data)
    }

    func upsert(_ table: String, body: [String: Any], onConflict: String? = nil) async throws {
        var query = ""
        if let conflict = onConflict {
            query = "?on_conflict=\(conflict)"
        }
        let urlStr = "\(baseURL)/rest/v1/\(table)\(query)"
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        let _ = try await request(urlStr, method: "POST", body: jsonData, prefer: "resolution=merge-duplicates,return=minimal")
    }

    // MARK: - Private

    private func request(_ urlStr: String, method: String = "GET", body: Data? = nil, prefer: String = "return=minimal", retried: Bool = false) async throws -> Data {
        guard let url = URL(string: urlStr) else { throw APIError.badURL }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(anonKey, forHTTPHeaderField: "apikey")
        req.setValue(prefer, forHTTPHeaderField: "Prefer")

        if let token = authToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            req.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
        }

        if let body = body { req.httpBody = body }

        let (data, response) = try await URLSession.shared.data(for: req)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0

        // Auto-refresh on 401
        if status == 401 && !retried {
            try await doRefreshToken()
            return try await request(urlStr, method: method, body: body, prefer: prefer, retried: true)
        }

        if status >= 400 {
            let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.server(status, msg)
        }

        return data
    }
}

// MARK: - Models

struct AuthResponse: Codable {
    let access_token: String
    let refresh_token: String
    let user: AuthUser
}

struct AuthUser: Codable {
    let id: String
    let email: String?
}

enum APIError: LocalizedError {
    case badURL, noToken, server(Int, String)
    var errorDescription: String? {
        switch self {
        case .badURL: return "Invalid URL"
        case .noToken: return "No auth token"
        case .server(let code, let msg): return "Server error \(code): \(msg)"
        }
    }
}
