//
//  Helpers.swift
//  ImageDescriberX
    

import SwiftUI
import BlurUIKit


extension UIColor {
    var color: Color {
        Color(self)
    }
}

extension String: @retroactive Identifiable {
    public var id: Self { self }
}

extension View {
    @ViewBuilder
    public func `if`(
        _ condition: @autoclosure () -> Bool,
        modified: (Self) -> some View
    ) -> some View {
        if condition() {
            modified(self)
        } else {
            self
        }
    }
}


struct GridPatternView<GirdStyle: ShapeStyle>: View {
    var verticalDivisions: Int = 4
    var horizontalDivisions: Int = 4
    var gridStyle: GirdStyle
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for index in 1..<verticalDivisions {
                    let vOffset: CGFloat = geometry.size.width / CGFloat(verticalDivisions) * CGFloat(index)
                    path.move(to: CGPoint(x: vOffset, y: 0))
                    path.addLine(to: CGPoint(x: vOffset, y: geometry.size.height))
                }
                for index in 1..<horizontalDivisions {
                    let hOffset: CGFloat = geometry.size.height / CGFloat(horizontalDivisions) * CGFloat(index)
                    path.move(to: CGPoint(x: 0, y: hOffset))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: hOffset))
                }
            }
            .stroke(gridStyle)
        }
    }
}


struct ShakeEffect: GeometryEffect {
    private let amount: CGFloat = 10
    private let shakesPerUnit = 3
    var animatableData: CGFloat

    var affineTransform: CGAffineTransform {
        CGAffineTransform(
            translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0
        )
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(affineTransform)
    }
}


struct StatusBarBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> VariableBlurView {
        let blurView = VariableBlurView()
        blurView.dimmingTintColor = nil
        
        return blurView
    }

    func updateUIView(_ uiView: VariableBlurView, context: Context) {}
}
