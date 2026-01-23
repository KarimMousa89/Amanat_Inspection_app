//
//  UserSelectionView.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 07/08/2025.
//

import SwiftUI
import SwiftData

struct UserSelectionView: View {
    @EnvironmentObject var coordinator: LoginCoordinator
    
    var body: some View {
        ZStack {
            SplashContentView()
            
            GeometryReader { proxy in
                let size = proxy.size
                let topSpace: CGFloat = 500/Screen.wireframeHeight * size.height
                let bottomSpace: CGFloat = 84/Screen.wireframeHeight * size.height
                let buttonWidth: CGFloat = 350/Screen.wireframeWidth * size.width

                VStack (alignment: .center) {
                    Spacer()
                        .frame(height: topSpace)
                    Button {
                        coordinator.push(.login(viewModel: LoginViewModelImpl()))
                    } label: {
                        Text("User".localized)
                            .font(.buttonsFont)
                        .frame(width: buttonWidth, height: 50)
                            .foregroundStyle(Color(.amanatPrimary))
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 5))
                            .padding(.bottom, 10)
                    }
                    
                    Button {
                        Task{
                            guard let cachingStorage = await SwiftDataStorage.make(domainTypes: [User.self, Book.self]) else {return}
                            let cachingManager = NewCachingManager(storage: cachingStorage)

                            await cachingManager.save(User(id: "1", name: "K1"), idOrKey: nil)
                            let user1_1 = await cachingManager.get(User.self, idOrKey: "1")

                            await  cachingManager.save("1", idOrKey: "1")
                            await  cachingManager.save("1_1", idOrKey: "1")
                            let data5 = await cachingManager.get(String.self, idOrKey: nil)

                            let data8 = await cachingManager.get(Int.self, idOrKey: nil)
                           
                            
                            await cachingManager.save(User(id: "2", name: "K2"), idOrKey: nil)
                            await cachingManager.save(User(id: "3", name: "K3"), idOrKey: nil)
                            
                            let user1 = await cachingManager.get(User.self, idOrKey: "2")
                            
                            let data = await cachingManager.get(User.self, idOrKey: nil)
                            
                            await cachingManager.remove(User.self, idOrKey: "2")
                            let data2 = await cachingManager.get(User.self, idOrKey: nil)
                            
                            await  cachingManager.remove(User.self, idOrKey: nil)
                            let data3 = await cachingManager.get(User.self, idOrKey: nil)
                            
                            await cachingManager.save(User(id: "1", name: "K1"), idOrKey: nil)
                            await cachingManager.save(User(id: "2", name: "K2"), idOrKey: nil)
                            await cachingManager.save(User(id: "3", name: "K3"), idOrKey: nil)
                            await  cachingManager.save("1", idOrKey: "1")
                            await  cachingManager.save("2", idOrKey: "3")
                            await  cachingManager.save("2", idOrKey: "3")
                            
                            let data4 = await cachingManager.get(User.self, idOrKey: nil)
                            let data51 = await cachingManager.get(String.self, idOrKey: nil)
                            let data81 = await cachingManager.get(Int.self, idOrKey: nil)
                           
                            await   cachingManager.clearAll()
                            
                            let data6 = await cachingManager.get(User.self, idOrKey: nil)
                            let data7 = await cachingManager.get(String.self, idOrKey: nil)
                        }
                            } label: {
                        Text("Visitor".localized)
                            .font(.buttonsFont)
                            .background(Color(.amanatPrimary))
                            .foregroundStyle(Color(.amanatSecondary))
                            .frame(width: buttonWidth, height: 50)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(.amanatSecondary), lineWidth: 1)
                            }
                    }
                    
                    Spacer()
                        .frame(height: bottomSpace)
                }.padding()
            }
        }
    }
}

#Preview {
//    UserSelectionView()
    TempView()
}

struct TempView :View {
    var body: some View {
        VStack {
            Button {
                
                
            } label: {
                Text("Visitor1".localized)
                    .font(.buttonsFont)
                    .background(Color(.amanatPrimary))
                    .foregroundStyle(Color(.amanatSecondary))
                    .frame(width: 300, height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.amanatSecondary), lineWidth: 1)
                    }
            }
            
            Button {
                // TODO: - check visitor path
            } label: {
                Text("Visitor".localized)
                    .font(.buttonsFont)
                    .background(Color(.amanatPrimary))
                    .foregroundStyle(Color(.amanatSecondary))
                    .frame(width: 300, height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.amanatSecondary), lineWidth: 1)
                    }
            }
            
            Button {
                // TODO: - check visitor path
            } label: {
                Text("Visitor".localized)
                    .font(.buttonsFont)
                    .background(Color(.amanatPrimary))
                    .foregroundStyle(Color(.amanatSecondary))
                    .frame(width: 300, height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.amanatSecondary), lineWidth: 1)
                    }
            }
            
            Button {
                // TODO: - check visitor path
            } label: {
                Text("Visitor".localized)
                    .font(.buttonsFont)
                    .background(Color(.amanatPrimary))
                    .foregroundStyle(Color(.amanatSecondary))
                    .frame(width: 300, height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.amanatSecondary), lineWidth: 1)
                    }
            }
            
            Button {
                // TODO: - check visitor path
            } label: {
                Text("Visitor".localized)
                    .font(.buttonsFont)
                    .background(Color(.amanatPrimary))
                    .foregroundStyle(Color(.amanatSecondary))
                    .frame(width: 300, height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.amanatSecondary), lineWidth: 1)
                    }
            }
        }
    }
}
