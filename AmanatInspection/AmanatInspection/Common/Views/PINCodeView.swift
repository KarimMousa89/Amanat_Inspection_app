//
//  PINCodeView.swift
//  ForthDemo
//
//  Created by Karim Mousa on 23/04/2025.
//

import Foundation
import SwiftUI

struct PINCodeView: View {
    private static let zeroWidthSpace = "\u{200B}"      // Zero-width space
    
    @Binding private var code: String
    var validationBlock: (() -> String?)
    
    @FocusState private var focusedField: Int?
    @State private var lastTexts: [String] = Array(repeating: PINCodeView.zeroWidthSpace, count: 4)
    @State private var shakeState = false
    @State private var errorMsg: String?
    
    init(code: Binding<String>, validationBlock: @escaping () -> String?) {
        _code = code
        self.validationBlock = validationBlock
    }
    
    var body: some View {
        VStack {
            
            HStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    VStack {
                        LimitedLengthTextFieldView(text: Binding(
                            get: { lastTexts[index] },
                            set: { newValue in
                                handleInput(newValue, at: index)
                            }
                        ), characterLimit: 1)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)// autofill from SMS
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .focused($focusedField, equals: index)
                        
                        if let errorMsg, !errorMsg.isEmpty {
                            Rectangle()
                                .foregroundStyle(.red)
                                .frame(width: 40, height: 2)
                                .offset(y: -8)
                        }
                    }
                }
            }
            .shake($shakeState)
            
            if let errorMsg, !errorMsg.isEmpty {
                Text(errorMsg)
                    .foregroundColor(.red)
                    .font(.bodyFont)
            }
        }
    }
    
    // MARK: - Input handler
    private func handleInput(_ newValue: String, at index: Int) {
        let oldValue = lastTexts[index]
        if oldValue == newValue {
            print("Equal values")
            return
        }
        
        print("KK:: handleInput \(newValue) count \(newValue.count) at \(index)")
        
        // Handle paste (e.g., "1234")
        if newValue.count >= 4 {
            print("handle paste")
            let digits = Array(newValue.prefix(4)).map { String($0) }
            for index in 0..<digits.count {
                lastTexts[index] = digits[index]
            }
            submitIfNeeded()
            return
        }
        
        // Handle normal input
        if newValue.count > 1 {
            let value = String(newValue
                .replacingOccurrences(of: PINCodeView.zeroWidthSpace, with: ""))
            lastTexts[index] = String(value.prefix(1))
        } else {
            lastTexts[index] = newValue
        }
        print("count \(lastTexts[index].count) at \(index)")
        
        // Move forward
        if lastTexts[index].count == 1 && index < 3 {
            print("handle Move forward")
            focusedField = index + 1
            lastTexts[index + 1] = PINCodeView.zeroWidthSpace
        }
        
        // Handle backspace
        if lastTexts[index].isEmpty
            && !oldValue.isEmpty
            && index > 0 {
            print("handle backspace")
            focusedField = index - 1
            lastTexts[index] = PINCodeView.zeroWidthSpace
        }
        
        submitIfNeeded()
    }
    
    // MARK: - Submission
    private func submitIfNeeded() {
        errorMsg = nil
        let finalCode = lastTexts.joined()
        code = finalCode.replacingOccurrences(of: PINCodeView.zeroWidthSpace, with: "")
        print("submit code: \(finalCode)")
        if code.count == 4 {
            errorMsg = validationBlock()
            if let errorMsg, !errorMsg.isEmpty {
                print("❌ Invalid code")
                shakeAndReset()
            } else {
                print("✅ Code valid: \(code)")
                focusedField = nil
            }
        }
    }
    
    private func shakeAndReset() {
        shakeState = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            code = ""
            lastTexts = Array(repeating: PINCodeView.zeroWidthSpace, count: 4)
            focusedField = 0
        }
    }
}

