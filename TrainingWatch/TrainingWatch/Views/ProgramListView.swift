import SwiftUI

struct ProgramListView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var programs: [WorkoutProgram] = []
    @State private var isLoading = true
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Ladataan...")
                } else if let error = error {
                    VStack(spacing: 8) {
                        Text("Virhe")
                            .fontWeight(.bold)
                        Text(error)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Button("Yritä uudelleen") { Task { await loadPrograms() } }
                    }
                } else if programs.isEmpty {
                    Text("Ei aktiivisia ohjelmia")
                        .foregroundColor(.gray)
                } else {
                    List(programs) { program in
                        NavigationLink(destination: ProgramDetailView(program: program)) {
                            HStack(spacing: 8) {
                                Text(program.displayEmoji)
                                    .font(.system(size: 20))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(program.name)
                                        .font(.system(size: 15, weight: .semibold))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Treenit")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { auth.logout() }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 12))
                    }
                }
            }
        }
        .task { await loadPrograms() }
    }

    func loadPrograms() async {
        isLoading = true
        error = nil
        do {
            let query = "select=id,name,emoji,is_active,sort_order&user_id=eq.\(auth.userId)&is_active=eq.true&order=sort_order.asc"
            let progs: [WorkoutProgram] = try await SupabaseClient.shared.fetch("workout_programs", query: query)
            programs = progs
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
