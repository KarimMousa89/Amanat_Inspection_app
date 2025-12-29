//
// Created By: Mobile Apps Academy
// Subscribe : https://www.youtube.com/@MobileAppsAcademy?sub_confirmation=1
// Medium Blob : https://medium.com/@mobileappsacademy
// LinkedIn : https://www.linkedin.com/company/mobile-apps-academy
// Twitter : https://twitter.com/MobileAppsAcdmy
// Lisence : https://github.com/Mobile-Apps-Academy/MobileAppsAcademyLicense/blob/main/LICENSE.txt
//

import SwiftUI

struct FloatingTextField: View {
    let placeholderText: String
    let textColor: Color
    let placeholderTextColor: Color
    let isSecure: Bool
    @Binding private var text: String
    
    let animation: Animation = .linear(duration: 0.25)
        
    @State private var placeholderOffset: CGFloat
    @State private var scaleEffectValue: CGFloat
    
    private var onTextAction: ((_ oldValue : String ,_ newValue : String) -> ())?
    
    init(placeholderText: String,
         text: Binding<String>,
         textColor: Color,
         placeholderTextColor: Color,
         isSecure: Bool = false,
         placeholderOffset: CGFloat = 0,
         scaleEffectValue: CGFloat = 1,
         onTextAction: ((_: String, _: String) -> Void)? = nil) {
        _text = text
        self.placeholderText = placeholderText
        self.textColor = textColor
        self.placeholderTextColor = placeholderTextColor
        self.isSecure = isSecure
        self.placeholderOffset = placeholderOffset
        self.scaleEffectValue = scaleEffectValue
        self.onTextAction = onTextAction
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Text(placeholderText)
                    .foregroundStyle(placeholderTextColor)
                    .font($text.wrappedValue.isEmpty ? .headline : .caption)
                    .offset(y: placeholderOffset)
                    .scaleEffect(scaleEffectValue, anchor: .leading)
                
                if isSecure {
                    SecureField("", text: $text)
                        .textContentType(.password)
                        .font(.headline)
                        .foregroundColor(.clear) // Hide the actual text
                        .accentColor(.clear) // Hide the cursor
                        .zIndex(1) // Ensure it's on top for tap detection
                    
                    Text(String(repeating: "*", count: text.count))
                                    .foregroundColor(textColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                } else {
                    TextField("", text: $text)
                        .font(.headline)
                        .foregroundStyle(textColor)
                }
            }
            .padding()
        }
        .onChange(of: text) { oldValue, newValue in
            withAnimation(animation) {
                placeholderOffset = $text.wrappedValue.isEmpty ? 0 : -25
                scaleEffectValue = $text.wrappedValue.isEmpty ? 1 : 0.75
            }
            onTextAction?(oldValue, newValue)
        }
    }
}

extension FloatingTextField {
    public func onTextChange(_ onTextAction: ((_ oldValue : String ,_ newValue : String) -> ())?) -> Self {
        var view = self
        view.onTextAction = onTextAction
        return view
    }
}
