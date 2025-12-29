//
//  CountdownView.swift
//  CountdownView
//
//  Created by Kukushkin, Vladimir on 01.03.2020.
//  Copyright © 2020 kukushechkin. All rights reserved.
//

import SwiftUI
import Combine

fileprivate enum CountdownState {
    case notStarted
    case running
    case done
}

fileprivate class Countdown: ObservableObject {
    @Published var timeLeft: Int = 0
    @Published var timeLeftFormatted: String = ""
    @Published var state: CountdownState = .notStarted
    
    private var cancellable: AnyCancellable?
    private var startDate = Date()
    
    func count(_ period: TimeInterval, onFinish: @escaping () -> Void) {
        self.state = .running
        self.timeLeft = 0
        self.startDate = Date()
        
        cancellable = Timer.publish(every: 1.0, on: RunLoop.main, in: .default)
            .autoconnect()
            .sink { time in
                if let timeDiffString = self.timeDifferenceString(from: self.startDate, to: time) {
                    self.timeLeft += 1
                    self.timeLeftFormatted = timeDiffString
                } else {
                    self.state = .done
                    self.cancellable?.cancel()
                    onFinish()
                }
            }
    }
    
    func timeDifferenceString(from start: Date, to end: Date) -> String? {
        let interval = Int(end.timeIntervalSince(start))
        let minutes = interval / 60
        let seconds = interval % 60
        if minutes == 0 && seconds == 0 {
            return nil
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct CountdownView: View {
    @ObservedObject private var countdown = Countdown()
    var period: TimeInterval
    var onFinish: () -> Void
    
    public var body: some View {
        Text("\(countdown.timeLeftFormatted)")
            .foregroundColor(.blueColor2)
            .font(.bodyFont)
            .onLoad {
                countdown.count(period, onFinish: onFinish)
            }
    }
}
