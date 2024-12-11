import SwiftUI

struct DiagnosticControls: View {
    @StateObject private var recorder = DiagnosticRecorder.shared
    @State private var showingReport = false
    @State private var reportText = ""
    
    var body: some View {
        VStack {
            if recorder.isRecording {
                Text("Recording...")
                    .foregroundStyle(.red)
                Button("Stop Recording") {
                    reportText = recorder.stopRecording()
                    showingReport = true
                }
            } else {
                Button("Start Recording") {
                    recorder.startRecording()
                }
            }
        }
        .sheet(isPresented: $showingReport) {
            NavigationStack {
                ScrollView {
                    Text(reportText)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                }
                .navigationTitle("Diagnostic Report")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        ShareLink(
                            item: reportText,
                            subject: Text("Diagnostic Report"),
                            message: Text("Workout Tracker Diagnostic Report")
                        )
                    }
                }
            }
        }
    }
} 