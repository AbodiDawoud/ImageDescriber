//
//  DescriberManager.swift
//  ImageDescriberX
    

import SwiftUI
import Observation



@Observable
class ImageDescriberManager {
    var importedImage: UIImage?
    var imageDescription: String?
    var describeRequest = DescribeRequest() {
        // Save the request on UserDefaults. When the app restarts, the options will be loaded.
        didSet { saveRequestToUserDefaults() }
    }
    var isDescribingAnyImage: Bool = false
    var shakeTrigger: CGFloat = 0

    
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKey = "describeRequest"
    
    
    init() {
        loadSavedRequest()
    }
    
    
    
    func describeImage() {
        if isDescribingAnyImage { return }
        
        guard let importedImage, let data = importedImage.pngData() else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return withAnimation {
                shakeTrigger += 1
            }
        }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        Task {
            isDescribingAnyImage = true
            imageDescription = await _describeImage(imageData: data)
            isDescribingAnyImage = false
        }
    }
    
    
    private func _describeImage(imageData: Data) async -> String {
        let url = URL(string: "https://imageprompt.org/api/ai/prompts/image")!

        var request = URLRequest(url: url)
        request.addValue("B2Pnz9Xn965OD6QY3x6rS5kUKQUKZjYlurTfQEgROe4", forHTTPHeaderField: "Authorization") // This field is fake, keep it if you want to publish to AppStore.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        

        
        let jsonData: [String: Any] = [
            "base64Url": imageData.base64EncodedString(),
            "instruction": describeRequest.detail.rawValue,
            "prompt": "Tone \(describeRequest.tone.rawValue)",
            "language": describeRequest.language.code,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonData)
        
        guard let data = try? await URLSession.shared.data(for: request).0,
              let response_json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let description = response_json["prompt"] as? String
        else { return "Failed to fetch the data." }
        

        return description
    }
    
    
    func redescribeImage() async -> String {
        guard let importedImage, let data = importedImage.pngData() else {
            return "Failed to redescribe image, try again."
        }
        
        return await _describeImage(imageData: data)
    }
    
    
    func onImportImage(_ image: UIImage) {
        importedImage = image
    }
    
    
    func reset() {
        withAnimation {
            importedImage = nil
            imageDescription = nil
        }
    }
    
    
    private func saveRequestToUserDefaults() {
        let data = try? JSONEncoder().encode(describeRequest)
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    
    private func loadSavedRequest() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            describeRequest = try! JSONDecoder().decode(DescribeRequest.self, from: data)
        }
    }
    
    func getImageFormattedSize(data: Data) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        

        return formatter.string(for: data.count) ?? "0 KB"
    }
}
