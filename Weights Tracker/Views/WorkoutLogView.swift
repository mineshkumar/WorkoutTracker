import SwiftUI

struct WorkoutLogView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var selectedExercises: Set<Exercise>
    @State var workout: Workout
    @State private var exerciseSets: [Exercise.ID: [ExerciseSet]] = [:]
    @State private var showingWeightPicker = false
    @State private var showingRepsPicker = false
    @State private var selectedSetIndex: Int?
    @State private var selectedExerciseId: UUID?
    @State private var shouldDismiss = false
    
    private let defaultReps = 8
    private let weightRange = Array(stride(from: 0, through: 500, by: 5))
    private let repsRange = Array(1...30)
    
    // Constants for layout
    private let cellHeight: CGFloat = 44  // Apple's standard touch target height
    private let cellSpacing: CGFloat = 16
    private let weightCellWidth: CGFloat = 120
    private let repsCellWidth: CGFloat = 100
    
    init(selectedExercises: Binding<Set<Exercise>>, workout: Workout) {
        self._selectedExercises = selectedExercises
        self._workout = State(initialValue: workout)
    }
    
    private func showPicker(for type: PickerType, index: Int, exerciseId: UUID) {
        // Close any open picker first
        showingWeightPicker = false
        showingRepsPicker = false
        
        // Set selection
        selectedSetIndex = index
        selectedExerciseId = exerciseId
        
        // Show requested picker
        switch type {
        case .weight:
            showingWeightPicker = true
        case .reps:
            showingRepsPicker = true
        }
    }
    
    private enum PickerType {
        case weight
        case reps
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Date Section
                Section {
                    DatePicker(
                        "Workout Date",
                        selection: $workout.date,
                        displayedComponents: [.date]
                    )
                }
                
                // Exercise Sections
                ForEach(workout.exercises) { exercise in
                    Section {
                        ForEach(Array(exerciseSets[exercise.id, default: []].enumerated()), id: \.element.id) { index, set in
                            HStack(spacing: 16) {
                                // Set Number
                                Text("Set \(index + 1)")
                                    .foregroundStyle(.secondary)
                                    .frame(width: 60, alignment: .leading)
                                
                                Spacer()
                                
                                // Weight Button
                                Button {
                                    showPicker(for: .weight, index: index, exerciseId: exercise.id)
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("\(Int(set.weight))")
                                            .font(.body.monospacedDigit().bold())
                                        Text("lbs")
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(width: weightCellWidth)
                                    .padding(.vertical, 8)
                                    .background(Color(uiColor: .systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(.plain)
                                
                                // Reps Button
                                Button {
                                    showPicker(for: .reps, index: index, exerciseId: exercise.id)
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("\(set.reps)")
                                            .font(.body.monospacedDigit().bold())
                                        Text("reps")
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(width: repsCellWidth)
                                    .padding(.vertical, 8)
                                    .background(Color(uiColor: .systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        Button(action: { addSet(for: exercise) }) {
                            Label("Add Set", systemImage: "plus.circle.fill")
                                .font(.body.weight(.medium))
                        }
                        .padding(.top, 8)
                    } header: {
                        Text(exercise.name)
                            .textCase(.uppercase)
                            .font(.headline)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        workoutManager.activeWorkout = nil
                        selectedExercises.removeAll()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        completeWorkout()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingWeightPicker) {
                NavigationStack {
                    Picker("Weight", selection: Binding(
                        get: { exerciseSets[selectedExerciseId ?? UUID()]?[selectedSetIndex ?? 0].weight ?? 0 },
                        set: { exerciseSets[selectedExerciseId ?? UUID()]?[selectedSetIndex ?? 0].weight = $0 }
                    )) {
                        ForEach(weightRange, id: \.self) { weight in
                            Text("\(weight) lbs").tag(Double(weight))
                        }
                    }
                    .pickerStyle(.wheel)
                    .navigationTitle("Select Weight")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingWeightPicker = false
                            }
                        }
                    }
                }
                .presentationDetents([.height(320)])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingRepsPicker) {
                NavigationStack {
                    Picker("Reps", selection: Binding(
                        get: { exerciseSets[selectedExerciseId ?? UUID()]?[selectedSetIndex ?? 0].reps ?? defaultReps },
                        set: { exerciseSets[selectedExerciseId ?? UUID()]?[selectedSetIndex ?? 0].reps = $0 }
                    )) {
                        ForEach(repsRange, id: \.self) { reps in
                            Text("\(reps) reps").tag(reps)
                        }
                    }
                    .pickerStyle(.wheel)
                    .navigationTitle("Select Reps")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingRepsPicker = false
                            }
                        }
                    }
                }
                .presentationDetents([.height(320)])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func getLastSetValues(for exercise: Exercise) -> (weight: Double, reps: Int) {
        // First check if there are any sets in the current workout
        if let lastSet = exerciseSets[exercise.id]?.last {
            return (lastSet.weight, lastSet.reps)
        }
        
        // If no sets in current workout, check exercise history
        if let lastHistory = exercise.history.last {
            return (lastHistory.maxWeight, 8) // Default to 8 reps if using historical weight
        }
        
        // Default values if no history
        return (0, 8)
    }
    
    private func initializeExerciseSets() {
        for exercise in workout.exercises {
            if exerciseSets[exercise.id] == nil {
                let (lastWeight, lastReps) = getLastSetValues(for: exercise)
                exerciseSets[exercise.id] = [
                    ExerciseSet(
                        id: UUID(),
                        weight: lastWeight,
                        reps: lastReps,
                        date: workout.date
                    )
                ]
            }
        }
    }
    
    private func addSet(for exercise: Exercise) {
        withAnimation {
            let lastSet = exerciseSets[exercise.id]?.last
            let (defaultWeight, defaultReps) = getLastSetValues(for: exercise)
            
            exerciseSets[exercise.id, default: []].append(
                ExerciseSet(
                    id: UUID(),
                    weight: lastSet?.weight ?? defaultWeight,
                    reps: lastSet?.reps ?? defaultReps,
                    date: workout.date
                )
            )
        }
    }
    
    private func completeWorkout() {
        let records = workout.exercises.map { exercise in
            ExerciseRecord(
                id: exercise.id,
                name: exercise.name,
                sets: exerciseSets[exercise.id] ?? []
            )
        }
        
        let session = WorkoutSession(
            date: workout.date,
            exercises: records
        )
        workoutManager.saveWorkout(session)
        workoutManager.activeWorkout = nil
        dismiss()
    }
} 