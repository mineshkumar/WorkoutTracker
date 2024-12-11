//
//  ContentView.swift
//  Weights Tracker
//
//  Created by Minesh Kumar on 12/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()
    @State private var selectedExercises: Set<Exercise> = []
    @State private var showingBugReport = false
    @State private var showingDebugOverlay = false
    
    var body: some View {
        TabView {
            WorkoutView(selectedExercises: $selectedExercises)
                .tabItem {
                    Label("Workout", systemImage: "figure.strengthtraining.traditional")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }
        .environmentObject(workoutManager)
        .onShake {
            showingBugReport = true
        }
        .sheet(isPresented: $showingBugReport) {
            BugReportView()
        }
        .sheet(isPresented: $showingDebugOverlay) {
            NavigationStack {
                List {
                    Section("Debug Info") {
                        DiagnosticControls()
                        Text("Memory Usage: X MB")
                        Text("Storage: Y MB free")
                    }
                }
                .navigationTitle("Debug")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            showingDebugOverlay = false
                        }
                    }
                }
            }
        }
        .onTapGesture(count: 3) {
            showingDebugOverlay = true
        }
    }
}

#Preview {
    ContentView()
}
