import SwiftUI

@main
struct TrainingWatchApp: App {
    @StateObject private var auth = AuthManager()

    var body: some Scene {
        WindowGroup {
            if auth.isLoggedIn {
                ProgramListView()
                    .environmentObject(auth)
            } else {
                LoginView()
                    .environmentObject(auth)
            }
        }
    }
}
