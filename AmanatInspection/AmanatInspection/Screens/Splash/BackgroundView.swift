//
//  BackgroundView.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 08/08/2025.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color(.amanatPrimary)
                .ignoresSafeArea(.all)
            
            GeometryReader { geometry in
                let size = geometry.size
                let mapHeight: CGFloat = 224/Screen.wireframeHeight * size.height
                
                VStack {
                    Image(.mapView)
                        .resizable()
                        .frame(width: size.width, height: mapHeight)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    BackgroundView()
}
