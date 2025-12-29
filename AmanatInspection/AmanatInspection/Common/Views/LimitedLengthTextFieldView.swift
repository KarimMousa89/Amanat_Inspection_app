//
//  LimitedLengthTextFeild.swift
//  ForthDemo
//
//  Created by Karim Mousa on 23/04/2025.
//

import Foundation
import SwiftUI

struct LimitedLengthTextFieldView : View {
    var titleKey: LocalizedStringKey
    @Binding var text: String
    var characterLimit:Int
    
    init(_ titleKey: LocalizedStringKey = "", text: Binding<String>, characterLimit: Int = 10) {
        self.titleKey = titleKey
        _text = text
        self.characterLimit = characterLimit
    }
    
    var body: some View {
        TextField(titleKey, text: $text)
            .onChange(of: text, { oldValue, newValue in
                if newValue.count > characterLimit {
                    text = String(newValue.prefix(characterLimit))
                }
            })
    }
}
