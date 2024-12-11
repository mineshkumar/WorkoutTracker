import SwiftUI

struct BugReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var description = ""
    @State private var steps = ""
    @State private var deviceInfo = UIDevice.current.systemVersion
    
    var body: some View {
        NavigationStack {
            Form {
                Section("What happened?") {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section("Steps to reproduce") {
                    TextEditor(text: $steps)
                        .frame(height: 100)
                }
                
                Section("Device Info") {
                    Text("iOS \(deviceInfo)")
                }
            }
            .navigationTitle("Report Issue")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        // TODO: Implement submission
                        dismiss()
                    }
                }
            }
        }
    }
} 