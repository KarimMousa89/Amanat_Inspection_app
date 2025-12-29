//
//  Common.swift
//  ForthDemo
//
//  Created by Karim Mousa on 12/10/1446 AH.
//

import Foundation
import SwiftUI

//MARK: - dismissKeyboard
@MainActor func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
