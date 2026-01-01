//
//  AmanatInspectionApp.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 06/08/2025.
//

import SwiftUI

@main
struct AmanatInspectionApp: App {
    private let coordinator = RootCoordinator()
    @UIApplicationDelegateAdaptor(AmanatInspectionAppDelegate.self) var appDelegate
  
    var body: some Scene {
        WindowGroup {
            coordinator
                .view()
        }
    }
    
    init() {
        // TODO: check for Jailbroken device
//        coordinator.handleJailbrokenDevice()
        appDelegate.coordinator = coordinator
    }
}

class AmanatInspectionAppDelegate: NSObject, UIApplicationDelegate {
    var coordinator: RootCoordinator?
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        NSLog("KK:: application open url: \(url)")
        if let components = componentsFor(url) {
            Task {
                await coordinator?.handleURLComponents(components)
            }
        }
        return true
    }
}

func componentsFor(_ url: URL) -> URLComponents? {
    NSLog("KK:: handleIncomingURL: \(url)")
    
    guard url.scheme == "amanatinspectionapp" else {
        return nil
    }
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        NSLog("KK:: Invalid URL")
        return nil
    }
    
    return components
}
