//
//  FirstTabView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

//Users list & Add new Book
struct FirstTabView<ViewModel: FirstTabViewModel>: View {
    @Environment(\.firstTabCoordinator) var coordinator
    
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        print("FirstTabView init")
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack {
                let keys = Array(viewModel.books.keys).sorted()
                List {
                    ForEach(keys, id: \.self) { key in
                        Section(header: Text("\(key)")) {
                            ForEach(viewModel.books[key] ?? []) { book in
                                HStack {
                                    Button("Push \(book.title)") {
                                        viewModel.didTapPush(route: FirstTabRoute.details(makeViewModel: {
                                            FirstTabDetailsViewModelImpl(book: book)
                                        }))
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                    Button("Present \(book.title)") {
                                        viewModel.didTapPresent(route: FirstTabRoute.details(makeViewModel: {
                                            FirstTabDetailsViewModelImpl(book: book, isPresented: true)
                                        }))
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                    Button("PushFull \(book.title)") {
                                        viewModel.didTapPush(route: FirstTabRoute.details(makeViewModel: {
                                            FirstTabDetailsViewModelImpl(book: book)
                                        }))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                
                HStack {
                    Spacer()
                    VStack {
                        ForEach(viewModel.books.keys.sorted(), id: \.self) { letter in
                            Button(action:{
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            }) {
                                Text(letter)
                                    .font(.system(size: 12))
                                    .padding(2)
                            }
                        }
                    }
                }
            }
            .onAppear {
                print("tabBarHidden = false")
                viewModel.viewAppeared()
            }
            .task{
                await viewModel.fetchBooks()
            }
            .toolbar(viewModel.tabBarHidden ?.hidden : .visible, for: .tabBar)
        }
    }
}
