import SwiftUI

struct DebugOverlay: View {
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            if isVisible {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Debug Info")
                        .font(.headline)
                    
                    DiagnosticControls()
                        .padding(.vertical)
                    
                    Text("Memory Usage: \(getMemoryUsage())")
                    Text("Storage: \(getStorageInfo())")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .allowsHitTesting(isVisible)
        .overlay(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(count: 3) {
                    withAnimation {
                        isVisible.toggle()
                    }
                }
                .allowsHitTesting(!isVisible)
        )
    }
    
    private func getMemoryUsage() -> String {
        return "X MB"
    }
    
    private func getStorageInfo() -> String {
        return "Y MB free"
    }
} 