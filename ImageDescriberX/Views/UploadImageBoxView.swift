//
//  UploadBoxView.swift
//  ImageDescriberX


import SwiftUI


struct UploadImageBoxView: View {
    @Binding var showImagePicker: Bool
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upload Image")
                .font(.satoshiBold(17))
            
            Button {
                showImagePicker.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(scheme == .light ? 0.07 : 0.2))
                    
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.quinary, lineWidth: 1)

                    
                    VStack(spacing: 28) {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .font(.system(size: 42, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                        
                        VStack(spacing: 6) {
                            Text("Click here to upload an image")
                                .font(.satoshiRegular(16).weight(.medium))
                            
                            Text("Supports PNG, JPEG, GIF, WebP")
                                .font(.satoshiRegular(14))
                                .opacity(0.8)
                        }
                    }
                    .padding(.vertical, 30)
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
        }
    }
}

