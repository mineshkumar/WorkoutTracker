import Foundation

struct Workout: Identifiable {
    let id = UUID()
    var date: Date
    var exercises: [Exercise]
} 