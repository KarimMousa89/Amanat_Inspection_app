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
    @MainActor static let defaultValue: any RootCoordinating = AppRootCoordinatorImp()
}

extension EnvironmentValues {
    @MainActor var rootCoordinator: any RootCoordinating {
        get { self[RootCoordinatorKey.self] }
        set { self[RootCoordinatorKey.self] = newValue }
    }
}

// MARK: - LoginCoordinatorEnvironmentKey
private struct LoginCoordinatorKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: AnyNavigationModalCoordinator = AnyNavigationModalCoordinator(LoginCoordinator(navigator: TempLoginNavigator()))
}

extension EnvironmentValues {
    @MainActor var loginCoordinator: AnyNavigationModalCoordinator<LoginRoute> {
        get { self[LoginCoordinatorKey.self] }
        set { self[LoginCoordinatorKey.self] = newValue }
    }
}

// MARK: - LoginNavigatingCoordinatorEnvironmentKey
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

// MARK: - HomeCoordinatorEnvironmentKey
private struct HomeCoordinatorKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: AnyTabCoordinator<HomeTab, HomeCrossTabRoute> = AnyTabCoordinator(HomeCoordinator(navigator: TempHomeNavigator()))
}

extension EnvironmentValues {
    @MainActor var homeCoordinator: AnyTabCoordinator<HomeTab, HomeCrossTabRoute> {
        get { self[HomeCoordinatorKey.self] }
        set { self[HomeCoordinatorKey.self] = newValue }
    }
}

// MARK: - HomeNavigatingCoordinatorEnvironmentKey
private struct HomeNavigatorKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: any HomeNavigating = TempHomeNavigator()
}

extension EnvironmentValues {
    @MainActor var homeNavigator: any HomeNavigating {
        get { self[HomeNavigatorKey.self] }
        set { self[HomeNavigatorKey.self] = newValue }
    }
}

final class TempHomeNavigator: HomeNavigating {
    func logoutDidSuccess() {}
}

// MARK: - FirstTabCoordinatorEnvironmentKey
private struct FirstTabCoordinatorKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: AnyNavigationModalCoordinator = AnyNavigationModalCoordinator(FirstTabCoordinator())
}

extension EnvironmentValues {
    @MainActor var firstTabCoordinator: AnyNavigationModalCoordinator<FirstTabRoute> {
        get { self[FirstTabCoordinatorKey.self] }
        set { self[FirstTabCoordinatorKey.self] = newValue }
    }
}

// MARK: - SecondTabCoordinatorEnvironmentKey
private struct SecondTabCoordinatorKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: AnyNavigationModalCoordinator = AnyNavigationModalCoordinator(SecondTabCoordinator())
}

extension EnvironmentValues {
    @MainActor var secondTabCoordinator: AnyNavigationModalCoordinator<SecondTabRoute> {
        get { self[SecondTabCoordinatorKey.self] }
        set { self[SecondTabCoordinatorKey.self] = newValue }
    }
}
