//
//  JailbrokenView.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 07/08/2025.
//

import SwiftUI

struct JailbrokenView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            GeometryReader { geometry in
                let size = geometry.size
                let topSpacing = 70/Screen.wireframeHeight * size.height
                VStack{
                    Spacer()
                        .frame(height: topSpacing)
                    Rectangle()
                        .foregroundStyle(.white)
                }.frame(height: size.height + Screen.bottomSafeAreaHeight)
            }
            
            VStack {
                Spacer()
                
                Text("Warning")
                    .font(.screenTitleFont)
                    .foregroundColor(.amanatPrimary)
               
                Text("Jailbroken_device_not_supported")
                    .font(.bodyFont)
                    .foregroundStyle(.amanatBlackText)
                    .padding(.horizontal, 32)
                
                Spacer()
                PoweredByTahakomView()
            }
        }
    }
}

#Preview {
    JailbrokenView()
}

struct PoweredByTahakomView: View {
    var body: some View {
        HStack {
            Text("Powered_By")
                .font(.bodyFont)
                .foregroundStyle(.amanatBlackText)
            
            Image(.tahakomLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
            
            Text("2024")
                .font(.bodyFont)
                .foregroundStyle(.amanatBlackText)
            
            Text("c")
                .font(.bodyFont)
                .foregroundStyle(.amanatBlackText)
                .padding(.all, 5)
                .padding(.bottom, 3)
                .overlay {
                    Circle()
                        .stroke(.black, lineWidth: 1)
                }
        }
    }
}
