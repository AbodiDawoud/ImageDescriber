//
//  DescriptionView.swift
//  ImageDescriberX

import SwiftUI
import NotchMyProblem



struct DescriptionView: View {
    @State private var description: String
    @State private var isRegenerating: Bool = false
    @State private var showImagePicker: Bool = false
    
    @Environment(ImageDescriberManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    
    init(_ description: String) {
        self._description = .init(initialValue: description)
    }
    
    
    var body: some View {
        ScrollView {
            Image(uiImage: manager.importedImage!)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 500)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(radius: 5)
                .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.primary.quaternary, lineWidth: 1)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 25) {
                    HStack {
                        Button(action: copyResults) {
                            Label("Copy", systemImage: "document.on.document")
                                .labelStyle(PlainLabelStyle(.indigo))
                        }
                        
                        Button(action: regenerateDescription) {
                            Label("Regenerate", systemImage: "arrow.clockwise")
                                .labelStyle(PlainLabelStyle(.green))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    
                    Text(description.replacingOccurrences(of: "\"", with: ""))
                        .font(.satoshiRegular(18))
                        .textSelection(.enabled)
                        .redacted(reason: isRegenerating ? .placeholder : .privacy)
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 12)
            }
            .padding(.horizontal)
        }
        .statusBarHidden()
        .animation(.smooth, value: isRegenerating)
        .overlay {
            TopologyButtonsView(
                leadingButton: {
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "arrow.left")
                            .modifier(NotchButtonStyleModifier())
                    }
                },
                trailingButton: {
                    Button(action: { showImagePicker = true }) {
                        Text("More")
                            .modifier(NotchButtonStyleModifier())
                    }
                }
            )
        }
        .sheet(isPresented: $showImagePicker) {
            PHPhotoPicker {
                manager.importedImage = $0
                regenerateDescription()
            }
            .ignoresSafeArea()
        }
    }
    
    func regenerateDescription() {
        if isRegenerating { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        Task {
            isRegenerating = true
            self.description = await manager.redescribeImage()
            isRegenerating = false
        }
    }

    func copyResults() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        UIPasteboard.general.string = description
    }
}


// Helper styles
fileprivate struct PlainLabelStyle: LabelStyle {
    let color: Color
    
    init(_ color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundColor(color)
            
            configuration.title
        }
        .font(.satoshiRegular(15))
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.thinMaterial, in: .buttonBorder)
        .overlay {
            RoundedRectangle(cornerRadius: 8).stroke(.gray.tertiary, lineWidth: 1)
        }
    }
}

fileprivate struct NotchButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .labelStyle(.iconOnly)
            .frame(width: 65, height: 30)
            .font(.footnote.weight(.semibold))
            .background(.thinMaterial)
            .foregroundStyle(Color.primary)
            .clipShape(Capsule())
    }
}
