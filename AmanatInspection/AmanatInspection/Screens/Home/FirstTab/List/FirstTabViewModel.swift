//
//  FirstTabViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

struct Book: Identifiable, Hashable {
    var id = UUID()
    let title: String
}

@MainActor
protocol FirstTabViewModel {
    var coordinator: AnyNavigationModalCoordinator<FirstTabRoute>? { get set }
    var tabBarHidden: Bool {get set}
    var books: [String:[Book]] { get set }
    func viewAppeared()
    func fetchBooks() async
    func didTapPush(book: Book)
    func didTapPresent(book: Book)
    func didTapFullPush(book: Book)
}

@MainActor @Observable
class FirstTabViewModelImpl: FirstTabViewModel {
    func didTapPush(book: Book) {
        let route = FirstTabRoute.details(makeViewModel: {
            FirstTabDetailsViewModelImpl(book: book)
        })
        coordinator?.push(route)
    }
    
    func didTapPresent(book: Book) {
        let route = FirstTabRoute.details(makeViewModel: {
            FirstTabDetailsViewModelImpl(book: book, isPresented: true)
        })
        coordinator?.presentModal(route)
    }
    
    func didTapFullPush(book: Book) {
        tabBarHidden = true
        let route = FirstTabRoute.details(makeViewModel: {
            FirstTabDetailsViewModelImpl(book: book)
        })
        coordinator?.push(route)
    }
    
    var coordinator: AnyNavigationModalCoordinator<FirstTabRoute>? = nil
    var tabBarHidden: Bool = false// TODO: move to the navigation coordinator
    var books: [String:[Book]] = [:]
    
    init(coordinator: AnyNavigationModalCoordinator<FirstTabRoute>? = nil) {
        self.coordinator = coordinator
    }
    func viewAppeared() {
        tabBarHidden = false
    }
    func fetchBooks() async {
        do{
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } catch {
            
        }
        
        self.books = ["K": [Book(title: "Karim"), Book(title: "Kamal"), Book(title: "Karam")],
                      "Z": [Book(title: "Zozo"), Book(title: "Zeinab"), Book(title: "Zalabya")],
                      "M": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "N": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "R": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "O": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "P": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "A": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "B": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "C": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "D": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "E": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")],
                      "F": [Book(title: "Marwa"), Book(title: "Mero"), Book(title: "Muhamed")]]
    }
}
