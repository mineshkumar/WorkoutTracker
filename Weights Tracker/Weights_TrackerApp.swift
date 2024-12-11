//
//  Weights_TrackerApp.swift
//  Weights Tracker
//
//  Created by Minesh Kumar on 12/10/24.
//

import SwiftUI

@main
struct Weights_TrackerApp: App {
    @State private var showingBugReport = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onShake {
                    showingBugReport = true
                }
                .sheet(isPresented: $showingBugReport) {
                    BugReportView()
                }
        }
    }
}

// Shake gesture extension
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
            action()
        }
    }
}
