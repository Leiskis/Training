import SwiftUI

@MainActor
class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userId: String = ""
    @Published var error: String?

    init() {
        // Check if we have a stored token
        if let uid = KeychainHelper.get("pt_user_id"),
           KeychainHelper.get("pt_access_token") != nil {
            userId = uid
            isLoggedIn = true
        }
    }

    func login(email: String, password: String) async {
        error = nil
        do {
            let auth = try await SupabaseClient.shared.signIn(email: email, password: password)
            userId = auth.user.id
            isLoggedIn = true
        } catch {
            self.error = error.localizedDescription
        }
    }

    func logout() {
        KeychainHelper.delete("pt_access_token")
        KeychainHelper.delete("pt_refresh_token")
        KeychainHelper.delete("pt_user_id")
        isLoggedIn = false
        userId = ""
    }
}
