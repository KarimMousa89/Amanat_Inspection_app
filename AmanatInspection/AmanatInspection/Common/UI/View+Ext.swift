//
//  View+Ext.swift
//  ForthDemo
//
//  Created by TWI on 07/12/2024.
//

import SwiftUI

// MARK: - onLoad
struct FirstAppearModifier: ViewModifier {
    @State private var isViewLoaded = false //.. to maintain the state when the view is re-drawn
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !isViewLoaded {
                    isViewLoaded = true
                    action()
                }
            }
    }
}

extension View {
    func onLoad(perform action: @escaping () -> Void) -> some View {
        self.modifier(FirstAppearModifier(action: action))
        //.. creates new instance every call, that's why isViewLoaded is a state not a normal variable to maintain the state when the view is re-drawn
    }
}

// MARK: - Shake

struct Shake<Content: View>: View {
    /// Set to true in order to animate
    @Binding var shake: Bool
    /// How many times the content will animate back and forth
    var repeatCount = 3
    /// Duration in seconds
    var duration = 0.8
    /// Range in pixels to go back and forth
    var offsetRange = 10.0

    @ViewBuilder let content: Content
    var onCompletion: (() -> Void)?

    @State private var xOffset = 0.0

    var body: some View {
        content
            .offset(x: xOffset)
            .onChange(of: shake, { oldValue, newValue in
                guard newValue else { return }
                animate {
                    shake = false
                    onCompletion?()
                }
            })
    }

    func animate(completed: @escaping () -> Void) {
        let factor1 = 0.9
        let eachDuration = duration * factor1 / CGFloat(repeatCount)

        backAndForthAnimation(duration: eachDuration, offset: offsetRange, count: repeatCount)
        
        let factor2 = 0.1
        withAnimation(.linear(duration: duration * factor2), completionCriteria: .removed) {
            xOffset = 0.0
        } completion: {
            completed()
        }
    }
    
    func backAndForthAnimation(duration: CGFloat, offset: CGFloat, count: Int) {
        guard count > 0 else {
            return
        }
        let halfDuration = duration / 2
        withAnimation(.linear(duration: halfDuration), completionCriteria: .removed) {
            xOffset = offsetRange
        } completion: {
            withAnimation(.linear(duration: halfDuration), completionCriteria: .removed) {
                xOffset = -offsetRange
            } completion: {
                backAndForthAnimation(duration: duration, offset: offset, count: count-1)
            }
        }
    }
}

extension View {
    func shake(_ shake: Binding<Bool>,
               repeatCount: Int = 4,
               duration: CGFloat = 0.5,
               offsetRange: CGFloat = 10,
               onCompletion: (() -> Void)? = nil) -> some View {
        Shake(shake: shake,
              repeatCount: repeatCount,
              duration: duration,
              offsetRange: offsetRange) {
            self
        } onCompletion: {
            onCompletion?()
        }
    }
}

//MARK: - Selectable Rounded Corner
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

//MARK: - View intrinsic height
struct ViewHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

extension View {
    func onHeightChange(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ViewHeightKey.self, value: proxy.size.height)
//                        .onLoad {
//                            //.. view height is zero in loading, so we need to resubmit the height once appeared
//                            onChange(proxy.size.height)
//                        }
                }
            )
            .onPreferenceChange(ViewHeightKey.self, perform: onChange)
    }
}
