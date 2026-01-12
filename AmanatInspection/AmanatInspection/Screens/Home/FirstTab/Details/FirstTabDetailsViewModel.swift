//
//  FirstTabDetailsViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

@MainActor
protocol FirstTabDetailsViewModel {
    var coordinator: (any NavigationModalCoordinating)? {get set}
    var book: Book { get }
    var isPresented: Bool { get }
    func didTapBack()
}

@MainActor @Observable
class FirstTabDetailsViewModelImpl: FirstTabDetailsViewModel {
    var coordinator: (any NavigationModalCoordinating)? = nil
    var book: Book
    var isPresented: Bool
    
    init(book: Book, isPresented: Bool = false) {
        self.book = book
        self.isPresented = isPresented
    }
    
    func didTapBack() {
        if isPresented {
            coordinator?.dismissModal()
        } else {
            coordinator?.pop()
        }
    }
}
