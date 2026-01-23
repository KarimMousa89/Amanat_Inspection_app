//
//  ThirdTabViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

@MainActor
protocol ThirdTabViewModel {
    var coordinator: (AnyTabCoordinator<HomeTab, HomeCrossTabRoute>)? {get set}
    var navigator: (any HomeNavigating)? {get set}
    func didTapLogout()
    func didTapDeeplinkSimulation()
    func didTapSwitchToFirstTab()
}

@MainActor @Observable
final class ThirdTabViewModelImpl: ThirdTabViewModel {
    var coordinator: (AnyTabCoordinator<HomeTab, HomeCrossTabRoute>)? = nil
    var navigator: (any HomeNavigating)? = nil
    
    func didTapDeeplinkSimulation() {
        if let urlComponents = URLComponents(string: "fifthDemo://showUser?userId=5") {
            coordinator?.handleURLComponents(urlComponents)
        }
    }
    
    func didTapSwitchToFirstTab() {
        coordinator?.perform(on: .first, action: .push(.bookDetais(book: Book(title: "Karim"))), switchTab: true)
//            coordinator.perform(on: .first, actionType: .push, route: .bookDetais(book: Book(title: "Karim")), switchTab: true)
    }
    
    func didTapLogout() {
        navigator?.logoutDidSuccess()
    }
}

        
