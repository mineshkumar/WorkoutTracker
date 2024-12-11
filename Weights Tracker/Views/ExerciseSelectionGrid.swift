import SwiftUI

struct ExerciseSelectionGrid: View {
    @Binding var selectedExercises: Set<Exercise>
    var onExerciseSelected: (Exercise) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Exercise.preloadedExercises) { exercise in
                    Button {
                        onExerciseSelected(exercise)
                    } label: {
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
    }
} 