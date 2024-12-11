import SwiftUI
import Charts

struct ExerciseChartView: View {
    let exercise: Exercise
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selectedMetric = "Max Weight"
    
    let metrics = ["Max Weight", "Total Volume"]
    
    var exerciseHistory: [ExerciseHistory] {
        workoutManager.getExerciseHistory(for: exercise.id)
    }
    
    private func formatDate(_ date: Date) -> String {
        date.formatted(.dateTime.month(.abbreviated).day())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: exercise.iconName)
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                Text(exercise.name)
                    .font(.headline)
                Spacer()
                if !exerciseHistory.isEmpty {
                    Picker("Metric", selection: $selectedMetric) {
                        ForEach(metrics, id: \.self) { metric in
                            Text(metric)
                        }
                    }
                    .labelsHidden()
                }
            }
            .padding(.horizontal)
            
            if exerciseHistory.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("Progress charts will appear here after you log your first workout")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color(uiColor: .systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                Chart {
                    ForEach(exerciseHistory) { record in
                        LineMark(
                            x: .value("Date", record.date),
                            y: .value("Weight", selectedMetric == "Max Weight" ? record.maxWeight : record.totalVolume)
                        )
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                        .symbolSize(30)
                        
                        AreaMark(
                            x: .value("Date", record.date),
                            y: .value("Weight", selectedMetric == "Max Weight" ? record.maxWeight : record.totalVolume)
                        )
                        .foregroundStyle(Gradient(colors: [Color.accentColor.opacity(0.2), .clear]))
                    }
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let value = value.as(Double.self) {
                                Text("\(Int(value))")
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 7)) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel {
                                Text(formatDate(date))
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    ExerciseChartView(
        exercise: Exercise(
            name: "Bench Press",
            iconName: "figure.strengthtraining.functional",
            history: Exercise.generateMockHistory(baseWeight: 185)
        )
    )
    .padding()
} 