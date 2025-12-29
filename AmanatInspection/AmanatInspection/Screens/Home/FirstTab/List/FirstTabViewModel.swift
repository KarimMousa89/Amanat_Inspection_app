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
