//
//  SplashViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

@MainActor
protocol SplashViewModel: ObservableObject {
    var onloadFinished: ((Bool) -> Void) { get }
    func load() async throws
}

@MainActor @Observable
final class SplashViewModelImpl: SplashViewModel {
    var onloadFinished: ((Bool) -> Void)
    let dataProcessor = DataProcessor()
    
    init(onloadFinished: @escaping (Bool) -> Void) {
        self.onloadFinished = onloadFinished
    }
    
    func load() async throws {
        // Perform work on background thread
        await self.dataProcessor.processData(Data())
        _ = await self.dataProcessor.getProcessedResult() ?? ""
        
        // Perform work on background thread
        _ = try await Task.detached {
            // TODO: - load user data to check if loggedin
            try await Task.sleep(nanoseconds: 1_000_000_000)
//            print("Thread isMain: \(Thread.isMainThread)")
            return false
        }.value
        
        // back to Main thread
        onloadFinished(false)
    }
}

// A non-isolated function to perform the heavy calculation.
// Being non-isolated means it can run on any thread.
func performHeavyCalculation(on data: Data) -> String {
    print("Starting heavy calculation on a background thread...")
    Thread.sleep(forTimeInterval: 2.0) // Simulate 2 seconds of work
    let result = "Processed: \(String(data: data, encoding: .utf8) ?? "")"
    print("Finished heavy calculation.")
    return result
}

actor DataProcessor {
    private var _processedResult: String? // Private mutable state

    var processedResult: String? {
        _processedResult
    }

    func processData(_ data: Data) async {
        // This method runs on the actor's isolated executor
        let result = performHeavyCalculation(on: data)
        _processedResult = result
    }

    func getProcessedResult() -> String? {
        // This method also runs on the actor's isolated executor
        return _processedResult
    }
}
