//
//  FirstTabViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

struct Book: Identifiable, Hashable {
    var id: String
    let title: String
}

@MainActor
protocol FirstTabViewModel: ObservableObject {
    var books: [String:[Book]] { get set }
    
    func fetchBooks() async
}

@MainActor
class FirstTabViewModelImpl: FirstTabViewModel {
    @Published var books: [String:[Book]] = [:]
    
    func fetchBooks() async {
        do{
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } catch {
            
        }
        
        self.books = ["K": [Book(id: "1", title: "Karim"), Book(id: "1", title: "Kamal"), Book(id: "1", title: "Karam")],
                      "Z": [Book(id: "1", title: "Zozo"), Book(id: "1", title: "Zeinab"), Book(id: "1", title: "Zalabya")],
                      "M": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "N": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "R": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "O": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "P": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "A": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "B": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "C": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "D": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "E": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")],
                      "F": [Book(id: "1", title: "Marwa"), Book(id: "1", title: "Mero"), Book(id: "1", title: "Muhamed")]]
    }
}
