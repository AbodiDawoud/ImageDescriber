//
//  RequestInfoView.swift
//  ImageDescriberX
    

import SwiftUI

struct RequestConfigView: View {
    @Binding var request: DescribeRequest
    @Environment(\.colorScheme) private var scheme
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configuration")
                .font(.satoshiBold(17))
            
            VStack {
                HStack {
                    Label("Detail Level", systemImage: "line.horizontal.3")
                    Spacer()
                    Picker("", selection: $request.detail) {
                        ForEach(DetailLevel.allCases, id: \.self) {
                            Text($0.displayName).tag($0)
                        }
                    }
                }
                
                
                divider
                
                
                HStack {
                    Label("Tone", systemImage: "face.smiling")
                    Spacer()
                    Picker("", selection: $request.tone) {
                        ForEach(Tone.allCases, id: \.self) {
                            Text($0.displayName).tag($0)
                        }
                    }
                }
                
                
                divider
                
                
                HStack {
                    Label("Language", systemImage: "globe.americas.fill")
                        
                    Spacer()
                    
                    Picker("", selection: $request.language) {
                        ForEach(Language.allCases, id: \.self) {
                            Text($0.displayName).tag($0)
                        }
                    }
                }
            }
            .tint(.gray)
            .font(.satoshiRegular(16.5))
            .padding(.leading, 20)
            .padding(.vertical, 16)
            .padding(.trailing, 10)
            .background(
                .gray.opacity(scheme == .light ? 0.07 : 0.2),
                in: .rect(cornerRadius: 17.5)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.quinary, lineWidth: 1)
            }
        }
    }
    
    private var divider: some View {
        Divider()
            .padding(.leading, -20)
            .padding(.trailing, -10)
            .padding(.vertical, 1)
    }
}
