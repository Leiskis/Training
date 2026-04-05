import SwiftUI
import WatchKit

struct SetCheck: Codable {
    let exercise_name: String?
    let set_number: Int?
    let done: Bool?
    let performed_reps: String?
    let performed_weight: Double?
}

struct ProgramDetailView: View {
    @EnvironmentObject var auth: AuthManager
    let program: WorkoutProgram

    @State private var exercises: [WorkoutExercise] = []
    @State private var setChecks: [String: [Int: SetCheck]] = [:] // exerciseName -> {setNum -> check}
    @State private var isLoading = true
    @State private var error: String?
    @State private var timerSeconds = 0
    @State private var timerRunning = false
    @State private var timerTask: Task<Void, Never>?

    var tabId: String {
        let slots = ["prog1", "prog2", "prog3"]
        return slots[min(program.sort_order ?? 0, 2)]
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Ladataan...")
            } else if let error = error {
                VStack(spacing: 4) {
                    Text("Virhe").fontWeight(.bold)
                    Text(error).font(.system(size: 10)).foregroundColor(.gray)
                }
            } else if exercises.isEmpty {
                Text("Ei liikkeitä").foregroundColor(.gray)
            } else {
                List {
                    // Timer
                    Section {
                        HStack {
                            Text(formatTime(timerSeconds))
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundColor(timerRunning ? .green : .white)
                            Spacer()
                            if timerRunning {
                                Button(action: stopTimer) {
                                    Image(systemName: "pause.fill").font(.system(size: 18)).foregroundColor(.orange)
                                }.buttonStyle(.plain)
                            } else {
                                Button(action: startTimer) {
                                    Image(systemName: "play.fill").font(.system(size: 18)).foregroundColor(.green)
                                }.buttonStyle(.plain)
                                if timerSeconds > 0 {
                                    Button(action: resetTimer) {
                                        Image(systemName: "xmark").font(.system(size: 14)).foregroundColor(.gray)
                                    }.buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // Exercises with sets
                    ForEach(exercises.indices, id: \.self) { i in
                        let ex = exercises[i]
                        let setCount = ex.sets ?? 3
                        let doneCount = countDoneSets(exerciseName: ex.exerciseName, setCount: setCount)

                        Section(header: HStack {
                            Text(ex.exerciseName).font(.system(size: 13, weight: .semibold))
                            Spacer()
                            if doneCount > 0 {
                                Text("\(doneCount)/\(setCount)")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.green)
                            }
                        }) {
                            ForEach(1...setCount, id: \.self) { setNum in
                                let isDone = setChecks[ex.exerciseName]?[setNum]?.done ?? false

                                Button(action: {
                                    toggleSetCheck(exerciseName: ex.exerciseName, setNum: setNum, done: !isDone)
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 18))
                                            .foregroundColor(isDone ? .green : .gray)

                                        Text("#\(setNum)")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.gray)
                                            .frame(width: 24)

                                        Text(ex.repsDisplay)
                                            .font(.system(size: 13))
                                            .foregroundColor(isDone ? .gray : .white)

                                        Text(ex.weightDisplay)
                                            .font(.system(size: 13))
                                            .foregroundColor(isDone ? .gray : .white)

                                        Spacer()
                                    }
                                }
                                .buttonStyle(.plain)
                                .listRowBackground(isDone ? Color.green.opacity(0.06) : Color.clear)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(program.displayName)
        .task { await loadExercises() }
        .onDisappear { timerTask?.cancel() }
    }

    // MARK: - Helpers

    func countDoneSets(exerciseName: String, setCount: Int) -> Int {
        guard let checks = setChecks[exerciseName] else { return 0 }
        return (1...setCount).filter { checks[$0]?.done == true }.count
    }

    // MARK: - Data Loading

    func loadExercises() async {
        isLoading = true
        do {
            let exQuery = "select=id,exercise_id,sort_order,sets,reps,target_weight&user_id=eq.\(auth.userId)&program_id=eq.\(program.id)&order=sort_order.asc"
            let rawData = try await SupabaseClient.shared.fetchRaw("workout_day_exercises", query: exQuery)
            var exRows: [WorkoutExercise] = try JSONDecoder().decode([WorkoutExercise].self, from: rawData)

            let libQuery = "select=id,name,muscle_group"
            let library: [ExerciseLibraryItem] = try await SupabaseClient.shared.fetch("exercise_library", query: libQuery)
            let libMap = Dictionary(uniqueKeysWithValues: library.map { ($0.id, $0) })

            for i in exRows.indices {
                if let lib = libMap[exRows[i].exercise_id] {
                    exRows[i].exerciseName = lib.name
                    exRows[i].muscleGroup = lib.muscle_group ?? ""
                }
            }

            // Load set_checks
            let checkQuery = "select=exercise_name,set_number,done,performed_reps,performed_weight&user_id=eq.\(auth.userId)&tab_id=eq.\(tabId)"
            let checkRows: [SetCheck] = try await SupabaseClient.shared.fetch("set_checks", query: checkQuery)
            var checkMap: [String: [Int: SetCheck]] = [:]
            for c in checkRows {
                guard let name = c.exercise_name, let num = c.set_number else { continue }
                if checkMap[name] == nil { checkMap[name] = [:] }
                checkMap[name]![num] = c
            }

            exercises = exRows
            setChecks = checkMap
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Set Toggle

    func toggleSetCheck(exerciseName: String, setNum: Int, done: Bool) {
        if setChecks[exerciseName] == nil { setChecks[exerciseName] = [:] }
        setChecks[exerciseName]![setNum] = SetCheck(
            exercise_name: exerciseName, set_number: setNum,
            done: done, performed_reps: nil, performed_weight: nil
        )

        WKInterfaceDevice.current().play(done ? .success : .click)

        Task {
            let seconds = done && timerRunning ? timerSeconds : nil
            var body: [String: Any] = [
                "user_id": auth.userId,
                "tab_id": tabId,
                "exercise_name": exerciseName,
                "set_number": setNum,
                "done": done,
                "updated_at": ISO8601DateFormatter().string(from: Date())
            ]
            if let s = seconds { body["checked_at_seconds"] = s }
            else { body["checked_at_seconds"] = NSNull() }

            try? await SupabaseClient.shared.upsert("set_checks", body: body, onConflict: "user_id,tab_id,exercise_name,set_number")
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

    func stopTimer() { timerRunning = false; timerTask?.cancel() }
    func resetTimer() { stopTimer(); timerSeconds = 0 }

    func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
