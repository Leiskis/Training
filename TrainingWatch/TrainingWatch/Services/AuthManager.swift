import SwiftUI
import Combine

@MainActor
class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userId: String = ""
    @Published var error: String?

    // Shared timer state (visible across views)
    @Published var activeTimerProgramId: String?
    @Published var timerSeconds: Int = 0
    @Published var timerRunning: Bool = false
    var timerTask: Task<Void, Never>?

    func startTimer(programId: String) {
        activeTimerProgramId = programId
        timerRunning = true
        timerTask = Task { @MainActor in
            while !Task.isCancelled && timerRunning {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if timerRunning { timerSeconds += 1 }
            }
        }
    }

    func stopTimer() {
        timerRunning = false
        timerTask?.cancel()
    }

    func resetTimer() {
        stopTimer()
        timerSeconds = 0
        activeTimerProgramId = nil
    }

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
