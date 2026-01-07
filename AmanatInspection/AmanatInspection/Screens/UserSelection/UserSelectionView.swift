//
//  UserSelectionView.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 07/08/2025.
//

import SwiftUI

struct UserSelectionView: View {
    @Environment(\.loginCoordinator) var coordinator
    
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
                        coordinator.resetToNewRoot(.login(makeViewModel: {
                            LoginViewModelImpl(coordinator: coordinator)
                        }))
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
                        // TODO: - check visitor path
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
    UserSelectionView()
}
