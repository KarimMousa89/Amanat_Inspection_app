//
//  ThirdTabCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 10/07/2025.
//

import Foundation
import SwiftUI

@MainActor @Observable
class ThirdTabCoordinator: Coordinator {
    func view() -> some View {
       ThirdTabView()
            .environment(self)
    }
}
