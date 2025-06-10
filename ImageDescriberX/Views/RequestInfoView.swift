//
//  RequestInfoView.swift
//  ImageDescriberX
    

import SwiftUI

struct RequestDetailView: View {
    @Binding var request: DescribeRequest
    
    var body: some View {
        GroupBox {
            HStack {
                Label("Detail Level", systemImage: "quotelevel")
                Spacer()
                Picker("", selection: $request.detail) {
                    ForEach(DetailLevel.allCases, id: \.self) {
                        Text($0.displayName).tag($0)
                    }
                }
            }
            
            HStack {
                Label("Tone", systemImage: "face.smiling")
                Spacer()
                Picker("", selection: $request.tone) {
                    ForEach(Tone.allCases, id: \.self) {
                        Text($0.displayName).tag($0)
                    }
                }
            }
            
            HStack {
                Label("Language", systemImage: "globe")
                Spacer()
                Picker("", selection: $request.language) {
                    ForEach(Language.allCases, id: \.self) {
                        Text($0.displayName).tag($0)
                    }
                }
            }
        } label: {
            VStack(alignment: .leading) {
                Text("Configuration")
                    .font(.satoshiBold(17))
                Text("Customize your alt text generation settings!")
                    .font(.satoshiRegular(15.4))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 4)
            }
        }
    }
}

/*
VStack(alignment: .leading) {
    Label("Context (Optional)", systemImage: "textformat.size")
    TextField(
        "Provide additional context about the image to improve the accuracy",
        text: $request.context,
        axis: .vertical
    )
    .padding()
    .frame(minHeight: 80, alignment: .topLeading)
    .background(.gray.opacity(0.1), in: .rect(cornerRadius: 8))
}
*/
