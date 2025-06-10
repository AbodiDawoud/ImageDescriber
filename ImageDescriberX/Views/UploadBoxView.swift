//
//  UploadBoxView.swift
//  ImageDescriberX
    

import SwiftUI


struct UploadBoxView: View {
    @Binding var showImagePicker: Bool
    @State private var trimStart: CGFloat = 0.0
    
    private let length: CGFloat =  0.08
    private let animationDuration: Double = 4.0
    private let autoReverse: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Upload Image")
                .font(.satoshiBold(17))
            
            Button {
                showImagePicker.toggle()
            } label: {
                VStack(spacing: 30) {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .font(.system(size: 40, weight: .medium))
                        .shadow(color: .purple, radius: 40)
                        .symbolRenderingMode(.hierarchical)
                    
                    VStack(spacing: 6.2) {
                        Text("Click here to upload an image")
                        Text("Supports PNG, JPEG, GIF, WebP")
                    }
                    .font(.satoshiRegular(15))
                    .opacity(0.8)
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .background(.gray.quinary, in: .rect(cornerRadius: 15))
                .background(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .trim(from: trimStart, to: trimStart + length)
                        .stroke(strokeStyle, lineWidth: 4)
                        .onAppear(perform: animateLine)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    func animateLine() {
        let anim = Animation.linear(duration: animationDuration).repeatForever(autoreverses: autoReverse)
        withAnimation(anim) {
            trimStart = 1.0
        }
    }
    
    var strokeStyle: LinearGradient {
        LinearGradient(colors: [.clear, .indigo, .red, .blue, .purple, .clear],
                       startPoint: .leading,
                       endPoint: .trailing
        )
    }
}
