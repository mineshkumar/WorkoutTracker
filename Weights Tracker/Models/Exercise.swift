import Foundation

struct ExerciseHistory: Identifiable {
    let id = UUID()
    let date: Date
    let maxWeight: Double
    let totalVolume: Double  // weight * reps across all sets
}

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String
    var history: [ExerciseHistory]
    
    static let preloadedExercises = [
        Exercise(name: "Deadlift", 
                iconName: "figure.strengthtraining.traditional",
                history: generateMockHistory(baseWeight: 225)),
        Exercise(name: "Bench Press", 
                iconName: "figure.strengthtraining.functional",
                history: generateMockHistory(baseWeight: 185)),
        Exercise(name: "Dumbbell Curls", 
                iconName: "figure.arms.open",
                history: generateMockHistory(baseWeight: 35)),
        Exercise(name: "Squats", 
                iconName: "figure.mixed.cardio",
                history: generateMockHistory(baseWeight: 205)),
        Exercise(name: "Leg Press", 
                iconName: "figure.strengthtraining.functional",
                history: generateMockHistory(baseWeight: 300)),
        Exercise(name: "Shoulder Press", 
                iconName: "figure.boxing",
                history: generateMockHistory(baseWeight: 115))
    ]
    
    static func generateMockHistory(baseWeight: Double) -> [ExerciseHistory] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<10).map { index in
            let date = calendar.date(byAdding: .day, value: -index * 3, to: today)!
            let randomVariation = Double.random(in: -5...5)
            return ExerciseHistory(
                date: date,
                maxWeight: baseWeight + randomVariation,
                totalVolume: (baseWeight + randomVariation) * Double.random(in: 12...15)
            )
        }.reversed()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
} 