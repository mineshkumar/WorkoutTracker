import SwiftUI

struct ExerciseLogView: View {
    let exercise: Exercise
    @State private var sets: [ExerciseSet] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<sets.count, id: \.self) { index in
                    HStack {
                        Text("Set \(index + 1)")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        TextField("Weight", value: $sets[index].weight, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                        
                        Text("lbs")
                        
                        TextField("Reps", value: $sets[index].reps, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .multilineTextAlignment(.trailing)
                        
                        Text("reps")
                    }
                }
            }
            .navigationTitle(exercise.name)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addNewSet) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .onAppear {
                if sets.isEmpty {
                    addNewSet()
                }
            }
        }
    }
    
    private func addNewSet() {
        sets.append(ExerciseSet(
            id: UUID(),
            weight: 0,
            reps: 0,
            date: Date()
        ))
    }
}

#Preview {
    ExerciseLogView(
        exercise: Exercise(
            name: "Bench Press",
            iconName: "figure.strengthtraining.functional",
            history: []  // Add empty history for preview
        )
    )
} 