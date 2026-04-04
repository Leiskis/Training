import Foundation

struct WorkoutProgram: Codable, Identifiable {
    let id: String
    let name: String
    let emoji: String?
    let is_active: Bool?
    let sort_order: Int?

    var displayEmoji: String {
        if let e = emoji, !e.isEmpty { return e }
        let fallback = ["💪","🔥","⚡","🏋️","🦵","🔙","🎯","🏃","⚽","🥊"]
        return fallback[(sort_order ?? 0) % fallback.count]
    }

    var displayName: String {
        "\(displayEmoji) \(name)"
    }
}

struct WorkoutExercise: Codable, Identifiable {
    let id: String
    let exercise_id: String
    let sort_order: Int
    let sets: Int?
    let reps: String?
    let target_weight: Double?

    // Enriched from exercise_library
    var exerciseName: String = "Unknown"
    var muscleGroup: String = ""

    enum CodingKeys: String, CodingKey {
        case id, exercise_id, sort_order, sets, reps, target_weight
    }

    var setsDisplay: String { "\(sets ?? 3)" }
    var repsDisplay: String { reps ?? "10" }
    var weightDisplay: String {
        guard let w = target_weight, w > 0 else { return "—" }
        return w.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(w)) kg" : "\(w) kg"
    }
    var summary: String {
        "\(setsDisplay) × \(repsDisplay)\(target_weight != nil && target_weight! > 0 ? " · \(weightDisplay)" : "")"
    }
}

struct ExerciseLibraryItem: Codable, Identifiable {
    let id: String
    let name: String
    let muscle_group: String?
}

struct ExerciseCheck: Codable {
    let user_id: String
    let tab_id: String
    let exercise_name: String
    let done: Bool
    let checked_at_seconds: Int?
    let updated_at: String
}
