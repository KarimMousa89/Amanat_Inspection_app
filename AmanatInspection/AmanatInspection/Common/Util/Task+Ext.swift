//
//  Task+Ext.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 14/01/2026.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func cancellableSleep(seconds: TimeInterval) async throws {
        try Task.checkCancellation()
        try await Task.sleep(for: .seconds(seconds))
        try Task.checkCancellation()
    }
}
