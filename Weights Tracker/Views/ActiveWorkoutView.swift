import SwiftUI
import Foundation

struct ActiveWorkoutView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selectedExercises: Set<Exercise> = []
    @State private var exerciseSets: [Exercise.ID: [ExerciseSet]] = [:]
    @State private var showingExerciseSelection = false
    @State private var showingWeightPicker = false
    @State private var showingRepsPicker = false
    @State private var selectedSetIndex: Int?
    @State private var selectedExerciseId: UUID?
    @State private var workoutDate = Date()
    
    var body: some View {
        NavigationStack {
            List {
                // Date Section
                Section {
                    DatePicker(
                        "Workout Date",
                        selection: $workoutDate,
                        displayedComponents: [.date]
                    )
                }
                
                // Exercise Sections
                ForEach(Array(selectedExercises)) { exercise in
                    Section {
                        // Sets
                        ForEach(Array(exerciseSets[exercise.id, default: []].enumerated()), id: \.element.id) { index, set in
                            HStack(spacing: 16) {
                                // ... existing set row layout ...
                            }
                        }
                        
                        Button(action: { addSet(for: exercise) }) {
                            Label("Add Set", systemImage: "plus.circle.fill")
                        }
                        .padding(.top, 8)
                    } header: {
                        Text(exercise.name)
                            .textCase(.uppercase)
                            .font(.headline)
                    }
                }
                
                // Add Exercise Section
                if !selectedExercises.isEmpty {
                    Section {
                        Button(action: { showingExerciseSelection = true }) {
                            Label("Add Exercise", systemImage: "plus.circle.fill")
                                .font(.headline)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(selectedExercises.isEmpty ? "Start Workout" : "Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                if !selectedExercises.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Save") {
                            saveWorkout()
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
            .overlay {
                if selectedExercises.isEmpty {
                    ExerciseSelectionGrid(
                        selectedExercises: $selectedExercises,
                        onExerciseSelected: { exercise in
                            withAnimation {
                                selectedExercises.insert(exercise)
                                initializeExerciseSets(for: exercise)
                            }
                        }
                    )
                }
            }
            .sheet(isPresented: $showingExerciseSelection) {
                NavigationStack {
                    ExerciseSelectionGrid(
                        selectedExercises: $selectedExercises,
                        onExerciseSelected: { exercise in
                            initializeExerciseSets(for: exercise)
                        }
                    )
                    .navigationTitle("Add Exercise")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                showingExerciseSelection = false
                            }
                        }
                    }
                }
            }
            // ... weight and reps pickers remain the same ...
        }
    }
    
    private func initializeExerciseSets(for exercise: Exercise) {
        if exerciseSets[exercise.id] == nil {
            let (lastWeight, lastReps) = getLastSetValues(for: exercise)
            exerciseSets[exercise.id] = [
                ExerciseSet(
                    id: UUID(),
                    weight: lastWeight,
                    reps: lastReps,
                    date: workoutDate
                )
            ]
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
    
    private func saveWorkout() {
        let records = Array(selectedExercises).map { exercise in
            ExerciseRecord(
                id: exercise.id,
                name: exercise.name,
                sets: exerciseSets[exercise.id] ?? []
            )
        }
        
        let session = WorkoutSession(
            date: workoutDate,
            exercises: records
        )
        workoutManager.saveWorkout(session)
        dismiss()
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
                    date: workoutDate
                )
            )
        }
    }
} 