////
////  SecondTabCoordinator.swift
////  FifthDemo
////
////  Created by Karim Mousa on 10/07/2025.
////
//
//import Foundation
//import SwiftUI
//
//enum SecondTabRoute: Identifiable, Hashable {
//    case list(viewModel: SecondTabViewModelImpl)
//    case details(viewModel: SecondTabDetailsViewModelImpl)
//    case addUser(coordinator: LoginCoordinator)
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    static func == (lhs: SecondTabRoute, rhs: SecondTabRoute) -> Bool {
//        lhs.id == rhs.id
//    }
//    var id: String {
//        switch self {
//        case .list: return "list"
//        case .details: return "details"
//        case .addUser: return "addUser"
//        }
//    }
//}
//
//struct SecondTabRouter {
//    @MainActor @ViewBuilder
//    static func view(for route: SecondTabRoute) -> some View {
//        switch route {
//        case .list(viewModel: let viewModel):
//            SecondTabView(viewModel: viewModel)
//        case .details(viewModel: let viewModel):
//            SecondTabDetailsView(viewModel: viewModel)
//        case .addUser(coordinator: let coordinator):
//            coordinator.view()
//        }
//    }
//}
//
//struct SecondTabCoordinatorView: View {
//    @EnvironmentObject var coordinator: SecondTabCoordinator
//    @State private var navPath = NavigationPath() // Local state
//    @State private var modalScene: SecondTabRoute?
//    
//    let listModel = SecondTabViewModelImpl()
//    
//    var body: some View {
//        NavigationStack(path: $navPath) {
//            SecondTabRouter.view(for: .list(viewModel: listModel))
//                .navigationDestination(for: SecondTabRoute.self) { route in
//                    SecondTabRouter.view(for: route)
//                        .navigationBarBackButtonHidden(true)
//                        .toolbar {
//                            ToolbarItem(placement: .navigationBarLeading) {
//                                Button {
//                                    coordinator.pop()
//                                    // TODO: what if more actions needed here. for example show the tabbar ??? => handle in view on disappear modifier
//                                } label: {
//                                    HStack {
//                                        Image(systemName: "chevron.backward")
//                                        Text("Back") // Force English text
//                                    }
//                                }
//                            }
//                        }
//                }
//        }
//        .sheet(item: $modalScene) { modal in
//            SecondTabRouter.view(for: modal)
//        }
//        .onAppear {
//            coordinator.onPathChange = { newPath in
//                navPath = newPath
//            }
//            
//            coordinator.onModalChange = { modal in
//                modalScene = modal
//            }
//            
//            coordinator.onURLComponentsEvent = { components in
//                guard let userId = components.queryItems?.first(where: { $0.name == "userId" })?.value else {
//                    NSLog("KK:: User Id not found")
//                    return
//                }
//                NSLog("KK:: User Id: \(userId)")
//                
//                listModel.selectUserId(userId) { user in
//                    coordinator.push(SecondTabRoute.details(viewModel: SecondTabDetailsViewModelImpl(user: user, onDismiss: {
//                        coordinator.pop()
//                    })))
//                }
//            }
//        }
//    }
//}
//
//@MainActor
//class SecondTabCoordinator: Coordinator, NavigationCoordinator, ModalCoordinator {
//    var onPathChange: ((NavigationPath) -> Void)?
//    var navPath = NavigationPath() {
//        didSet {
//            onPathChange?(navPath)
//        }
//    }
//    
//    var onModalChange: ((SecondTabRoute?) -> Void)?
//    var modalScene: SecondTabRoute?{
//        didSet {
//            onModalChange?(modalScene)
//        }
//    }
//    
//    func view() -> some View {
//        return SecondTabCoordinatorView()
//            .environmentObject(self)
//    }
//    
//    var onURLComponentsEvent: ((URLComponents) -> Void)?
//    func handleURLComponents(_ components: URLComponents) async{
//        let action = components.host
//        switch action {
//        case "showUser":
//            NSLog("KK:: User details action!")
//            do{
//                try await Task.sleep(nanoseconds: 500_000_000)
//            } catch {
//                
//            }
//            //onURLComponentsEvent is allocated in the will appear of the view, so give it some time
//            onURLComponentsEvent?(components)
//        default:
//            NSLog("KK:: Unknown URL action: \(String(describing: action))")
//        }
//    }
//}
