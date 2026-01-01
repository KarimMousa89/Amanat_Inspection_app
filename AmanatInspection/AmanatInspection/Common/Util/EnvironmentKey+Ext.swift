//
//  EnvironmentKey+Ext.swift
//  AmanatInspection
//
//  Created by Kemo on 29/12/2025.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @MainActor var appSettings: MyAppSettings {
        get { MyAppSettings() }
    }
}
