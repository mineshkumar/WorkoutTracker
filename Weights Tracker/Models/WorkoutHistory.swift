import Foundation

class WorkoutManager: ObservableObject {
    @Published var workoutHistory: [WorkoutSession] = []
    @Published var activeWorkout: WorkoutSession?
    
    func saveWorkout(_ workout: WorkoutSession) {
        workoutHistory.append(workout)
        activeWorkout = nil
        // TODO: Persist to storage
    }
    
    func startWorkout(exercises: [Exercise]) {
        activeWorkout = WorkoutSession(
            date: Date(),
            exercises: exercises.map { exercise in
                ExerciseRecord(
                    id: exercise.id,
                    name: exercise.name,
                    sets: []
                )
            }
        )
    }
    
    func getExerciseHistory(for exerciseId: UUID) -> [ExerciseHistory] {
        return workoutHistory
            .flatMap { session in
                session.exercises.compactMap { exercise -> ExerciseHistory? in
                    guard exercise.id == exerciseId else { return nil }
                    let totalVolume = exercise.sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
                    let maxWeight = exercise.sets.map { $0.weight }.max() ?? 0
                    return ExerciseHistory(
                        date: session.date,
                        maxWeight: maxWeight,
                        totalVolume: totalVolume
                    )
                }
            }
            .sorted { $0.date < $1.date }
    }
}

struct WorkoutSession: Identifiable {
    let id = UUID()
    let date: Date
    var exercises: [ExerciseRecord]
}

struct ExerciseRecord: Identifiable {
    let id: UUID  // This matches the Exercise.id
    let name: String
    var sets: [ExerciseSet]
} 