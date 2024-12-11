import Foundation
import os.log

class DiagnosticRecorder: ObservableObject {
    static let shared = DiagnosticRecorder()
    private let logger = Logger(subsystem: "com.yourapp.weightstracker", category: "diagnostics")
    
    @Published var isRecording = false
    private var sessionEvents: [DiagnosticEvent] = []
    private var sessionStartTime: Date?
    
    struct DiagnosticEvent: Codable {
        let timestamp: Date
        let eventType: String
        let description: String
        let viewIdentifier: String
        let additionalInfo: [String: String]
    }
    
    func startRecording() {
        sessionEvents.removeAll()
        sessionStartTime = Date()
        isRecording = true
        logEvent(type: "SESSION_START", description: "Started diagnostic recording")
    }
    
    func stopRecording() -> String {
        isRecording = false
        logEvent(type: "SESSION_END", description: "Ended diagnostic recording")
        return generateReport()
    }
    
    func logEvent(type: String, description: String, viewID: String = "", info: [String: String] = [:]) {
        guard isRecording else { return }
        
        let event = DiagnosticEvent(
            timestamp: Date(),
            eventType: type,
            description: description,
            viewIdentifier: viewID,
            additionalInfo: info
        )
        
        sessionEvents.append(event)
        logger.debug("[\(type)] \(description)")
    }
    
    private func generateReport() -> String {
        var report = "Diagnostic Report\n"
        report += "================\n"
        report += "Session Start: \(sessionStartTime?.formatted() ?? "Unknown")\n"
        report += "Session End: \(Date().formatted())\n\n"
        report += "Events:\n"
        
        for (index, event) in sessionEvents.enumerated() {
            report += "\n[\(index + 1)] \(event.timestamp.formatted(.dateTime.hour().minute().second()))"
            report += "\nType: \(event.eventType)"
            report += "\nDescription: \(event.description)"
            if !event.viewIdentifier.isEmpty {
                report += "\nView: \(event.viewIdentifier)"
            }
            if !event.additionalInfo.isEmpty {
                report += "\nAdditional Info:"
                event.additionalInfo.forEach { key, value in
                    report += "\n  - \(key): \(value)"
                }
            }
            report += "\n"
        }
        
        return report
    }
} 