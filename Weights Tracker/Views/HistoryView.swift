import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        NavigationStack {
            List {
                if workoutManager.workoutHistory.isEmpty {
                    ContentUnavailableView(
                        "No Workout History",
                        systemImage: "figure.run",
                        description: Text("Your completed workouts will appear here")
                    )
                } else {
                    ForEach(workoutManager.workoutHistory.reversed()) { session in
                        Section {
                            ForEach(session.exercises) { exercise in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(exercise.name)
                                        .font(.headline)
                                    
                                    ForEach(exercise.sets) { set in
                                        HStack {
                                            Text("\(Int(set.weight)) lbs")
                                            Text("×")
                                                .foregroundStyle(.secondary)
                                            Text("\(set.reps) reps")
                                        }
                                        .font(.subheadline)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        } header: {
                            Text(session.date.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
} 