//
//  ContentView.swift
//  ImageDescriberX
    

import SwiftUI
import BlurUIKit


struct ContentView: View {
    @State private var showImagePicker: Bool = false
    @State private var manager = ImageDescriberManager()
    @Environment(\.colorScheme) private var scheme
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                headerTextView
                
                if let image = manager.importedImage {
                    importedImageView(image)
                } else {
                    UploadImageBoxView(showImagePicker: $showImagePicker)
                }
                
                RequestConfigView(request: $manager.describeRequest)
                    .padding(.vertical, 15)
                
                describeButton
            }
            .padding()
            .background(alignment: .top) { gridBackgroundView }
        }
        .persistentSystemOverlays(.hidden)
        .overlay(alignment: .top) {
            StatusBarBlurView()
                .frame(maxHeight: 65, alignment: .top)
                .allowsHitTesting(false)
                .edgesIgnoringSafeArea(.top)
        }
        .sheet(isPresented: $showImagePicker) {
            PHPhotoPicker(onSelect: manager.onImportImage).ignoresSafeArea()
        }
        .fullScreenCover(item: $manager.imageDescription, onDismiss: manager.reset) {
            ResultsView($0).environment(manager)
        }
    }
    
    @ViewBuilder
    private var headerTextView: some View {
        let darkColors: [Color] = [
            Color(#colorLiteral(red: 0.6592999697, green: 0.4976742864, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7957118154, blue: 0.9133895636, alpha: 1)), Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        ]
        
        
        let headerGradient = LinearGradient(
            colors: scheme == .light ? [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))] : darkColors,
            startPoint: .leading,
            endPoint: .trailing
        )
        
        VStack {
            HStack {
                Text("Lighting Fast")
                    .font(.satoshiRegular(15).weight(.medium))
                
                Image(systemName: "bolt.fill")
                    .imageScale(.small)
                    .bold()
                    .foregroundStyle( Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)).gradient)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(.thickMaterial, in: .capsule)
            .overlay {
                Capsule()
                    .stroke(.gray.quaternary, lineWidth: 1.0)
            }
            
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
            .foregroundStyle(.background)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.primary, in: .capsule)
        }
        .buttonStyle(.plain)
        .modifier(ShakeEffect(animatableData: manager.shakeTrigger))
        .padding(.top, 10)
        .opacity(manager.isDescribingAnyImage ? 0.55 : 1)
        .animation(
            // I have no idea why repeatForever() never stops when isLoading is set back to false. I had to do this workaround.
            .linear(duration: 0.75).repeatCount(manager.isDescribingAnyImage ? 999 : 0),
            value: manager.isDescribingAnyImage
        )
    }
    
    
    private func importedImageView(_ image: UIImage) -> some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 500)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 8)
            
            HStack {
                Button(action: manager.reset) {
                    Image(systemName: "trash.fill")
                        .padding(9)
                        .foregroundStyle(.pink)
                        .background {
                            _UIBlurView().clipShape(.circle)
                        }
                }
                Spacer()
                
                Text(manager.getImageFormattedSize(data: image.pngData()!))
                    .font(.satoshiRegular(14).weight(.medium))
                    .padding(.vertical, 9)
                    .padding(.horizontal, 25)
                    .background {
                        _UIBlurView().clipShape(.capsule)
                    }
                
                Spacer()
                
                Button {
                    showImagePicker = true
                } label: {
                    Image(systemName: "plus")
                        .padding(9)
                        .background {
                            _UIBlurView().clipShape(.circle)
                        }
                }
            }
            .padding([.horizontal, .bottom], 6)
            .foregroundStyle(.white)
            .buttonStyle(.plain)
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

#Preview {
    ContentView()
}

fileprivate struct _UIBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let effect = UIBlurEffect(style: .systemChromeMaterialDark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

