//
//  LoginView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct LoginView<ViewModel: LoginViewModel>: View {
    @Environment(\.loginNavigator) var loginHandler
    
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            GeometryReader { geometry in
                let size = geometry.size
                let topSpacing = 70/Screen.wireframeHeight * size.height
                let bottomSpace: CGFloat = 0.1 * size.height

                VStack{
                    Spacer()
                        .frame(height: topSpacing)
                    
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.white)

                        VStack (alignment: .center) {
                            
                            Spacer()
                                .frame(maxHeight: 30)
                            
                            Image(.tawasolHorizontalLogo)
                            
                            Spacer()
                                .frame(maxHeight: 30)
                            
                            if let loginErrorMessage = viewModel.loginErrorMessage, !loginErrorMessage.isEmpty {
                                
                                ZStack {
                                    Rectangle()
                                        .foregroundStyle(.red)
                                        .clipShape(.rect(cornerRadius: 15))
                                    
                                    HStack{
                                        Image(.close)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 20)
                                        
                                        Text(loginErrorMessage)
                                            .font(.bodyFont)
                                            .foregroundStyle(.whiteText)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                }
                                .frame(width: size.width - 32, height: 30)
                            }
                            
                            FloatingTextFieldWithError(text: $viewModel.userName,
                                                       errorMessage: $viewModel.userNameErrorMessage,
                                                       width: size.width,
                                                       placeholderText: "Username".localized)
            
                            FloatingTextFieldWithError(text: $viewModel.password,
                                                       errorMessage: $viewModel.passwordErrorMessage,
                                                       width: size.width,
                                                       isSecure: true,
                                                       placeholderText: "Password".localized)
                            
                            HStack{
                                Button {
                                    viewModel.forgetPassword()
                                } label: {
                                    Text("Forget_Password?")
                                        .font(.bodyFont)
                                        .foregroundStyle(Color(.amanatPrimary))
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 4)
                            
                            HStack(spacing: 10) {
                                let captchaWidth = size.width - 32 - 50 - 10
                                Text(viewModel.displayedCaptcha)
                                    .font(.custom("Chalkduster", size: 45))
                                    .foregroundStyle(.amanatBlackText)
                                    .frame(width: captchaWidth, height: 50)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.amanatBlackText, lineWidth: 1)
                                    }.onAppear{
                                        print("captchaWidth \(captchaWidth)")
                                    }
                                
                                    Button {
                                        viewModel.regenerateCaptcha()
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 50, height: 50)
                                                .foregroundStyle(.amanatPrimary)
                                            
                                            Image(.refresh)
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                        }
                                    }
                            }
                            
                            FloatingTextFieldWithError(text: $viewModel.userCaptcha,
                                                       errorMessage: $viewModel.captchaErrorMessage,
                                                       width: size.width,
                                                       placeholderText: "Captcha".localized)
                            
                            Spacer()
                            
                            Button {
                                Task{
                                    await viewModel.login(handler: loginHandler)
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: size.width - 32, height: 50)
                                        .foregroundStyle(.amanatPrimary)
                                        .padding(.horizontal, 16)
                                    
                                    HStack{
                                        Image(.login)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.trailing, 8)
                                        
                                        Text("Login".localized)
                                            .font(.bodyFont)
                                            .foregroundColor(.whiteText)
                                    }
                                }
                            }
                            
                            Spacer()
                            PoweredByTahakomView()
                            Spacer()
                                .frame(height: bottomSpace)
                        }
                        .frame(width: geometry.size.width)
                        
                    }
                }.frame(height: size.height + Screen.bottomSafeAreaHeight)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let model = LoginViewModelImpl()
    LoginView {
        model
    }
}

struct FloatingTextFieldWithError : View {
    @Binding var text: String
    @Binding var errorMessage: String?
    var width: CGFloat
    var isSecure: Bool = false
    var placeholderText: String
    var textColor: Color = .amanatBlackText
    var placeholderTextColor: Color = .gray
    
    var body: some View {
        FloatingTextField(placeholderText: placeholderText,
                          text: $text,
                          textColor: textColor,
                          placeholderTextColor: placeholderTextColor,
                          isSecure: isSecure)
        .background(.lightGray)
        .clipShape(.rect(cornerRadius: 10))
        .frame(width: width - 32)
        .padding(.top, 8)
        
        if let errorMsg = errorMessage {
            Rectangle()
                .foregroundStyle(.red)
                .frame(width: width - 52, height: 2)
                .offset(y: -8)
            
            if !errorMsg.isEmpty {
                HStack{
                    Text(errorMsg)
                        .font(.bodyFont)
                        .foregroundStyle(.red)
                    Spacer()
                }
                .frame(width: width - 52)
                .offset(y: -12)
            }
        }
    }
}
