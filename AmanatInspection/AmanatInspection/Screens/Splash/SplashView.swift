//
//  SplashView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct SplashView<ViewModel: SplashViewModel>: View {
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        SplashContentView()
        .task { 
            do {
                try await viewModel.load()
            } catch {
                print("Error loading: \(error)")
            }
        }
    }
}

struct SplashContentView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            GeometryReader { geometry in
                let size = geometry.size
                let topSpacing = 140/Screen.wireframeHeight * size.height
                
                VStack {
                    Spacer()
                        .frame(height: topSpacing)
                    
                    HStack (spacing: 20) {
                        VStack {
                            Text("TAWASUL_AR")
                                .font(.titleFont)
                                .foregroundStyle(.whiteText)
                            
                            Text("TAWASUL_EN")
                                .font(.title2Font)
                                .foregroundStyle(.whiteText)
                        }
                        
                        Image(.logowhite)
                    }
                    Spacer()
                    
                    Text("Developed_Powered_Tahakom")
                        .font(.bodyFont)
                        .foregroundStyle(.whiteText)
                    
                    Image(.tahakomLogoWhite)
                }
                .frame(width: geometry.size.width, alignment: .center)
            }
        }
    }
}
