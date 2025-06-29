//
//  ContentView.swift
//  ImageDescriberX
    

import SwiftUI
import BlurUIKit


struct ContentView: View {
    @State private var showImagePicker: Bool = false
    @State private var manager = ImageDescriberManager()
    
    
    var body: some View {
        ScrollView {
            VStack {
                headerTextView
                
                if let image = manager.importedImage {
                    importedImageView(image)
                } else {
                    UploadBoxView(showImagePicker: $showImagePicker)
                }
                
                RequestDetailView(request: $manager.describeRequest)
                    .padding(.vertical, 15)
                
                describeButton
            }
            .padding()
            .background(alignment: .top) { gridBackgroundView }
        }
        .modifier(BlurOverlay())
        .sheet(isPresented: $showImagePicker) {
            PHPhotoPicker(onSelect: manager.onImportImage).ignoresSafeArea()
        }
        .fullScreenCover(item: $manager.imageDescription, onDismiss: manager.reset) {
            DescriptionView($0).environment(manager)
        }
    }
    
    @ViewBuilder
    private var headerTextView: some View {
        let headerGradient = LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
        
        VStack {
            HStack {
                Text("Lighting Fast")
                    .font(.satoshiRegular(15).weight(.medium))
                
                Image(systemName: "bolt.fill")
                    .imageScale(.small)
                    .foregroundStyle(.yellow)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(.thickMaterial, in: .capsule)
            
            Group {
                Text("Describe Images with") + Text(" AI Technology").foregroundStyle(headerGradient)
            }
            .font(.satoshiBlack(28))
            .multilineTextAlignment(.center)
        }
        .padding(.bottom, 42)
    }
    
    
    private var describeButton: some View {
        Button(action: manager.describeImage) {
            HStack {
                Text("Start Describe Image")
                    .font(.satoshiRegular(15))
                
               
                Image(systemName: "arrow.right")
                    .imageScale(.small)
            }
            .fontWeight(.medium)
            .foregroundStyle(.inversedLabel)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.primary, in: .capsule)
        }
        .buttonStyle(.plain)
        .modifier(ShakeEffect(animatableData: manager.shakeTrigger))
        .padding(.top, 10)
        .opacity(manager.isLoading ? 0.55 : 1)
        .animation(
            // I have no idea why repeatForever() never stops when isLoading is set back to false. I had to do this workaround.
            .linear(duration: 0.75).repeatCount(manager.isLoading ? 999 : 0),
            value: manager.isLoading
        )
    }
    
    
    private func importedImageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 500)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 8)
            .overlay(alignment: .bottomLeading) {
                Button(action: manager.reset) {
                    Image(systemName: "trash.fill")
                        .padding(9)
                        .background(.thinMaterial, in: .circle)
                        .padding([.leading, .bottom], 5.5)
                        .foregroundStyle(.red)
                }.buttonStyle(.plain)
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showImagePicker = true
                } label: {
                    Image(systemName: "plus")
                        .padding(9)
                        .background(.thinMaterial, in: .circle)
                        .padding([.trailing, .bottom], 5.5)
                }.buttonStyle(.plain)
            }
    }
    
    private var gridBackgroundView: some View {
        GridPatternView(
            verticalDivisions: 6,
            gridStyle: LinearGradient(
                colors: [
                    .gray.opacity(0.01),
                    .gray.opacity(0.3),
                    .gray.opacity(0.01)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .frame(width: 380, height: 175)
        .ignoresSafeArea(.all)
    }
}
