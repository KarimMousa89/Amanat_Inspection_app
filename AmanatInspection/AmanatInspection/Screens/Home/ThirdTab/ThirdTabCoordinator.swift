//
//  ThirdTabCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 10/07/2025.
//

import Foundation
import SwiftUI

class ThirdTabCoordinator: Coordinator {
    func view() -> some View {
       ThirdTabView()
            .environmentObject(self)
    }
}
