//
//  DescriptionView.swift
//  ImageDescriberX

import SwiftUI
import NotchMyProblem



struct ResultsView: View {
    @State private var description: String
    @State private var isRegenerating: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var haveCopiedDescription: Bool = false
    
    @Environment(ImageDescriberManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    
    init(_ description: String) {
        self._description = .init(initialValue: description)
    }
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                                .symbolRenderingMode(.hierarchical)
                                .labelStyle(PlainLabelStyle(.indigo))
                        }
                        
                        Button(action: regenerateDescription) {
                            Label("Regenerate", systemImage: "arrow.clockwise")
                                .labelStyle(PlainLabelStyle(.green))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    
                    Text(description)
                        .font(.satoshiRegular(18))
                        .textSelection(.enabled)
                        .padding(.horizontal, 2)
                        .redacted(reason: isRegenerating ? .placeholder : .privacy)
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
        .statusBarHidden()
        .persistentSystemOverlays(.hidden)
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



fileprivate struct PlainLabelStyle: LabelStyle {
    let color: Color
    @Environment(\.colorScheme) private var scheme
    
    init(_ color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundStyle(color.gradient)
                .fontWeight(.semibold)
            
            configuration.title
        }
        .font(.satoshiRegular(15))
        .padding(.horizontal, 10)
        .frame(height: 35)
        .background(.gray.opacity(scheme == .light ? 0.04 : 0.2), in: .capsule)
        .overlay {
            Capsule()
                .stroke(.gray.tertiary, lineWidth: 1)
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

#Preview {
    HStack {
        Button(action: {}) {
            Label("Copy", systemImage: "document.on.document")
                .symbolRenderingMode(.hierarchical)
                .labelStyle(PlainLabelStyle(.indigo))
        }
        
        Button(action: {}) {
            Label("Regenerate", systemImage: "arrow.clockwise")
                .labelStyle(PlainLabelStyle(.green))
        }
    }
    .buttonStyle(.plain)
}
