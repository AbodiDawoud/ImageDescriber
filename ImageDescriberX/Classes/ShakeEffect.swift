//
//  ShakeEffect.swift
//  ImageDescriberX


import SwiftUI

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
