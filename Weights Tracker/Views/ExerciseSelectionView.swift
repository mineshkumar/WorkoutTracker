import SwiftUI

struct ExerciseSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedExercises: Set<Exercise>
    let onStartWorkout: () -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Exercise.preloadedExercises) { exercise in
                        Button(action: {
                            if selectedExercises.contains(exercise) {
                                selectedExercises.remove(exercise)
                            } else {
                                selectedExercises.insert(exercise)
                            }
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: exercise.iconName)
                                    .font(.system(size: 24))
                                    .frame(width: 60, height: 60)
                                    .background(selectedExercises.contains(exercise) ? Color.accentColor : Color.accentColor.opacity(0.1))
                                    .foregroundStyle(selectedExercises.contains(exercise) ? .white : Color.accentColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                Text(exercise.name)
                                    .font(.headline)
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Start Workout") {
                        onStartWorkout()
                    }
                    .disabled(selectedExercises.isEmpty)
                }
            }
        }
    }
} 