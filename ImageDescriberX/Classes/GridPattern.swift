//
//  GridPatternView.swift
//  SwiftUIPatterns


import SwiftUI


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
