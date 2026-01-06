//
//  EnvironmentKey+Ext.swift
//  AmanatInspection
//
//  Created by Kemo on 29/12/2025.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @MainActor var appSettings: MyAppSettings {
        get { MyAppSettings() }
    }
}

// MARK: - RootCoordinatorEnvironmentKey
private struct RootCoordinatorKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: any RootCoordinating = RootCoordinator()
}

extension EnvironmentValues {
    @MainActor var rootCoordinator: any RootCoordinating {
        get { self[RootCoordinatorKey.self] }
        set { self[RootCoordinatorKey.self] = newValue }
    }
}
