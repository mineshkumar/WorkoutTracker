import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var selectedExercises: Set<Exercise>
    @State private var showingExerciseSelection = false
    @State private var showingWorkoutLog = false
    @State private var selectedChartExercise: Exercise? = Exercise.preloadedExercises.first
    
    init(selectedExercises: Binding<Set<Exercise>>) {
        self._selectedExercises = selectedExercises
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Workout Section
                Section {
                    if let activeWorkout = workoutManager.activeWorkout {
                        Button(action: { showingWorkoutLog = true }) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "clock.badge.checkmark.fill")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("Continue Workout")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                
                                Text(activeWorkout.exercises.map(\.name).joined(separator: " • "))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        Button(action: { showingExerciseSelection = true }) {
                            HStack {
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("Start Workout")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Workout")
                }
                
                // Progress Charts Section
                Section {
                    Picker("Select Exercise", selection: $selectedChartExercise) {
                        ForEach(Exercise.preloadedExercises) { exercise in
                            Text(exercise.name).tag(Optional(exercise))
                        }
                    }
                    .pickerStyle(.menu)
                    
                    if let exercise = selectedChartExercise {
                        ExerciseChartView(exercise: exercise)
                            .listRowInsets(EdgeInsets())
                            .padding(.top)
                    }
                } header: {
                    Text("Progress")
                }
            }
            .navigationTitle("Workout Tracker")
            .fullScreenCover(isPresented: $showingExerciseSelection) {
                ExerciseSelectionView(selectedExercises: $selectedExercises) {
                    workoutManager.startWorkout(exercises: Array(selectedExercises))
                    showingExerciseSelection = false
                    showingWorkoutLog = true
                }
            }
            .fullScreenCover(isPresented: $showingWorkoutLog) {
                if let activeWorkout = workoutManager.activeWorkout {
                    WorkoutLogView(
                        selectedExercises: $selectedExercises,
                        workout: Workout(
                            date: activeWorkout.date,
                            exercises: activeWorkout.exercises.map { record in
                                Exercise.preloadedExercises.first { $0.id == record.id }!
                            }
                        )
                    )
                }
            }
        }
    }
} 