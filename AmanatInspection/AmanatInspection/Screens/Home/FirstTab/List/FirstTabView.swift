//
//  FirstTabView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

//Users list & Add new Book
struct FirstTabView<ViewModel: FirstTabViewModel>: View {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var coordinator: FirstTabCoordinator
    
    @State private var tabBarHidden: Bool = false// TODO: move to the navigation coordinator
    
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
                                        coordinator.push(FirstTabRoute.details(viewModel: FirstTabDetailsViewModelImpl(book: book, onDismiss: {
                                            print("Push onDismiss")
                                            coordinator.pop()
                                        })))
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                    Button("Present \(book.title)") {
                                        coordinator.presentModal(FirstTabRoute.details(viewModel: FirstTabDetailsViewModelImpl(book: book, onDismiss: {
                                            print("presentModal onDismiss")
                                            coordinator.dismissModal()
                                        })))
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                    Button("PushFull \(book.title)") {
                                        print("tabBarHidden = true")
                                        tabBarHidden = true
                                        coordinator.push(FirstTabRoute.details(viewModel: FirstTabDetailsViewModelImpl(book: book, onDismiss: {
                                            print("PushFull onDismiss")
                                            coordinator.pop()
                                        })))
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
                                    print("scroll to \(letter)")
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
                tabBarHidden = false
            }
            .task{
                await viewModel.fetchBooks()
            }
            .toolbar(tabBarHidden ?.hidden : .visible, for: .tabBar)
        }
    }
}
