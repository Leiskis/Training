import SwiftUI

struct ProgramDetailView: View {
    @EnvironmentObject var auth: AuthManager
    let program: WorkoutProgram

    @State private var exercises: [WorkoutExercise] = []
    @State private var checks: [String: Bool] = [:] // exerciseName -> done
    @State private var isLoading = true
    @State private var timerSeconds = 0
    @State private var timerRunning = false
    @State private var timerTask: Task<Void, Never>?

    // Slot mapping: first active = prog1, second = prog2, etc.
    var tabId: String {
        let slots = ["prog1", "prog2", "prog3"]
        return slots[min(program.sort_order ?? 0, 2)]
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Ladataan...")
            } else {
                List {
                    // Timer section
                    Section {
                        HStack {
                            Text(formatTime(timerSeconds))
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundColor(timerRunning ? .green : .white)

                            Spacer()

                            if timerRunning {
                                Button(action: stopTimer) {
                                    Image(systemName: "pause.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.orange)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Button(action: startTimer) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.green)
                                }
                                .buttonStyle(.plain)

                                if timerSeconds > 0 {
                                    Button(action: resetTimer) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // Exercises
                    ForEach(exercises.indices, id: \.self) { i in
                        let ex = exercises[i]
                        let isDone = checks[ex.exerciseName] ?? false

                        Button(action: {
                            toggleCheck(exerciseName: ex.exerciseName, done: !isDone)
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 22))
                                    .foregroundColor(isDone ? .green : .gray)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(ex.exerciseName)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(isDone ? .gray : .white)
                                        .strikethrough(isDone)

                                    Text(ex.summary)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }

                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(isDone ? Color.green.opacity(0.08) : Color.clear)
                    }
                }
            }
        }
        .navigationTitle(program.displayName)
        .task { await loadExercises() }
        .onDisappear { timerTask?.cancel() }
    }

    // MARK: - Data Loading

    func loadExercises() async {
        isLoading = true
        do {
            // Load exercises for this program
            let exQuery = "select=id,exercise_id,sort_order,sets,reps,target_weight&user_id=eq.\(auth.userId)&program_id=eq.\(program.id)&order=sort_order.asc"
            var exRows: [WorkoutExercise] = try await SupabaseClient.shared.fetch("workout_day_exercises", query: exQuery)

            // Load exercise library for names
            let libQuery = "select=id,name,muscle_group"
            let library: [ExerciseLibraryItem] = try await SupabaseClient.shared.fetch("exercise_library", query: libQuery)
            let libMap = Dictionary(uniqueKeysWithValues: library.map { ($0.id, $0) })

            // Enrich exercises with names
            for i in exRows.indices {
                if let lib = libMap[exRows[i].exercise_id] {
                    exRows[i].exerciseName = lib.name
                    exRows[i].muscleGroup = lib.muscle_group ?? ""
                }
            }

            // Load checks
            let checkQuery = "select=exercise_name,done&user_id=eq.\(auth.userId)&tab_id=eq.\(tabId)"
            let checkRows: [ExerciseCheck] = try await SupabaseClient.shared.fetch("exercise_checks", query: checkQuery)
            var checkMap: [String: Bool] = [:]
            for c in checkRows { checkMap[c.exercise_name] = c.done }

            exercises = exRows
            checks = checkMap
        } catch {
            print("Load error: \(error)")
        }
        isLoading = false
    }

    // MARK: - Check Toggle

    func toggleCheck(exerciseName: String, done: Bool) {
        checks[exerciseName] = done

        // Haptic feedback
        WKInterfaceDevice.current().play(done ? .success : .click)

        Task {
            let seconds = done && timerRunning ? timerSeconds : nil
            var body: [String: Any] = [
                "user_id": auth.userId,
                "tab_id": tabId,
                "exercise_name": exerciseName,
                "done": done,
                "updated_at": ISO8601DateFormatter().string(from: Date())
            ]
            if let s = seconds { body["checked_at_seconds"] = s }
            else { body["checked_at_seconds"] = NSNull() }

            try? await SupabaseClient.shared.upsert("exercise_checks", body: body, onConflict: "user_id,tab_id,exercise_name")
        }
    }

    // MARK: - Timer

    func startTimer() {
        timerRunning = true
        timerTask = Task {
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
    }

    func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
