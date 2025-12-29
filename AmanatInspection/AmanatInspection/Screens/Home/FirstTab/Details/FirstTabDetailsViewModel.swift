//
//  FirstTabDetailsViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

protocol FirstTabDetailsViewModel: ObservableObject {
    var book: Book { get }
    var onDismiss: () -> Void { get }
}

class FirstTabDetailsViewModelImpl: FirstTabDetailsViewModel {
    var onDismiss: () -> Void
    @Published var book: Book
    
    init(book: Book, onDismiss: @escaping () -> Void) {
        self.book = book
        self.onDismiss = onDismiss
    }
}
