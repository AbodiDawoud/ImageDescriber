//
//  BlurUIKit++.swift
//  ImageDescriberX
    

import SwiftUI
import BlurUIKit



struct BlurOverlay: ViewModifier {
    var maxHeight: CGFloat
    
    init(maxHeight: CGFloat = 65) {
        self.maxHeight = maxHeight
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                StatusBarBlurView()
                    .frame(maxHeight: maxHeight, alignment: .top) // Pins to the top
                    .allowsHitTesting(false) // Avoids interference with touch interactions
                    .edgesIgnoringSafeArea(.top) // Ensure it covers the status bar
            }
    }
}


fileprivate struct StatusBarBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> VariableBlurView {
        let blurView = VariableBlurView()
        blurView.dimmingTintColor = nil
        
        return blurView
    }

    func updateUIView(_ uiView: VariableBlurView, context: Context) {}
}
