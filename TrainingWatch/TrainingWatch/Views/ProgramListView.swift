import SwiftUI

struct ProgramProgress {
    let done: Int
    let total: Int
    var isActive: Bool { done > 0 }
    var label: String {
        if total == 0 { return "" }
        if done == total { return "✓" }
        return "\(done)/\(total)"
    }
}

struct ProgramListView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var programs: [WorkoutProgram] = []
    @State private var progress: [String: ProgramProgress] = [:] // programId -> progress
    @State private var isLoading = true
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Ladataan...")
                } else if let error = error {
                    VStack(spacing: 8) {
                        Text("Virhe").fontWeight(.bold)
                        Text(error).font(.system(size: 12)).foregroundColor(.gray)
                        Button("Yritä uudelleen") { Task { await loadPrograms() } }
                    }
                } else if programs.isEmpty {
                    Text("Ei aktiivisia ohjelmia").foregroundColor(.gray)
                } else {
                    List(programs) { program in
                        NavigationLink(destination: ProgramDetailView(program: program)) {
                            HStack(spacing: 8) {
                                Text(program.displayEmoji)
                                    .font(.system(size: 20))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(program.name)
                                        .font(.system(size: 15, weight: .semibold))

                                    if let prog = progress[program.id], prog.isActive {
                                        HStack(spacing: 4) {
                                            Image(systemName: "flame.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.orange)
                                            Text(prog.label)
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                Spacer()

                                if let prog = progress[program.id], prog.isActive {
                                    if prog.done == prog.total {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.system(size: 16))
                                    } else {
                                        Text(prog.label)
                                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                                            .foregroundColor(.green)
                                    }
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

            // Load set_checks to show progress per program
            var progMap: [String: ProgramProgress] = [:]
            let slots = ["prog1", "prog2", "prog3"]

            for (i, prog) in progs.prefix(3).enumerated() {
                let tabId = slots[i]

                // Get exercise count (sets per exercise)
                let exQuery = "select=exercise_id,sets&user_id=eq.\(auth.userId)&program_id=eq.\(prog.id)"
                let exRows: [WorkoutExercise] = try await SupabaseClient.shared.fetch("workout_day_exercises", query: exQuery)
                let totalSets = exRows.reduce(0) { $0 + ($1.sets ?? 3) }

                // Get done count from set_checks
                let checkQuery = "select=set_number,done&user_id=eq.\(auth.userId)&tab_id=eq.\(tabId)&done=eq.true"
                let doneRows: [SetCheck] = try await SupabaseClient.shared.fetch("set_checks", query: checkQuery)

                progMap[prog.id] = ProgramProgress(done: doneRows.count, total: totalSets)
            }

            progress = progMap
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
