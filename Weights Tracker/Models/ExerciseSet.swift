import Foundation

struct ExerciseSet: Identifiable, Codable {
    let id: UUID
    var weight: Double
    var reps: Int
    var date: Date
} 