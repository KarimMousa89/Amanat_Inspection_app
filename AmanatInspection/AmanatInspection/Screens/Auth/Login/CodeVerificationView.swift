//
//  CodeVerificationView.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 23/08/2025.
//

import Foundation
import SwiftUI

struct CodeVerificationView: View {
    @State var code: String = ""
    @State var resendBtnVisible: Bool = false
    
    var body: some View {
        VStack {
            
            HStack{
                Image(.OTP)
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("Verification Code".localized)
                    .font(.bodyFont.bold())
                    .foregroundStyle(.amanatBlackText)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    ZStack{
                        Rectangle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.clear)
                        
                        Image(.close)
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
            }
            
            Text("Verification code sent to your phone".localized)
                .font(.bodyFont)
                .foregroundStyle(.amanatBlackText)
            
            PINCodeView(code: $code) {
                return nil
            }
            
            if !resendBtnVisible {
                HStack{
                    Text("will be able to resend after".localized)
                        .font(.bodyFont)
                        .foregroundColor(.amanatBlackText)
                    
                    CountdownView(period: 5*60) {
                        resendBtnVisible = true
                    }
                }
            } else {
                Button {
                    // TODO: resend action
                } label: {
                    Text("resend verification code".localized)
                        .font(.bodyFont)
                        .foregroundColor(.blueColor2)
                        .frame(width: .infinity, height: 40)
                }
            }
        }
    }
}
