//
//  Coordinator.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 11/01/2026.
//

import Foundation
import SwiftUI

@MainActor
protocol URLComponentsHandler {
    func handleURLComponents(_ components: URLComponents)
}

extension URLComponentsHandler {
    func handleURLComponents(_ components: URLComponents) {}
}

@MainActor
protocol Coordinator: AnyObject {
    associatedtype ViewType: View
    func view() -> ViewType
}
