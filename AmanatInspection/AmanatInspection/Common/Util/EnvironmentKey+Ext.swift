//
//  EnvironmentKey+Ext.swift
//  AmanatInspection
//
//  Created by Kemo on 29/12/2025.
//

import Foundation
import SwiftUI

// MARK: - AppSettingsEnvironmentKey
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

// MARK: - LoginCoordinatorEnvironmentKey
private struct LoginCoordinatorKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: AnyLoginCoordinator = AnyLoginCoordinator(LoginCoordinator(navigator: TempLoginNavigator()))
}

extension EnvironmentValues {
    @MainActor var loginCoordinator: AnyLoginCoordinator {
        get { self[LoginCoordinatorKey.self] }
        set { self[LoginCoordinatorKey.self] = newValue }
    }
}

// MARK: - LoginCoordinatorEnvironmentKey
private struct LoginNavigatorKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: any LoginNavigating = TempLoginNavigator()
}

extension EnvironmentValues {
    @MainActor var loginNavigator: any LoginNavigating {
        get { self[LoginNavigatorKey.self] }
        set { self[LoginNavigatorKey.self] = newValue }
    }
}

final class TempLoginNavigator: LoginNavigating {
    func loginDidSuccess() {}
}
