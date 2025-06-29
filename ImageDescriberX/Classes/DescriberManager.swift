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
    var isLoading: Bool = false
    var shakeTrigger: CGFloat = 0

    
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKey = "describeRequest"
    
    
    init() {
        loadSavedRequest()
    }
    
    
    
    func describeImage() {
        if isLoading || importedImage == nil {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return withAnimation {
                shakeTrigger += 1
            }
        }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        Task {
            isLoading = true
            imageDescription = await _describeImage()
            isLoading = false
        }
    }
    
    
    private func _describeImage() async -> String {
        let endpoint = URL(string: "https://www.alttextai.net/api/generate")!
        
        var request = URLRequest(url: endpoint)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("B2Pnz9Xn965OD6QY3x6rS5kUKQUKZjYlurTfQEgROe4", forHTTPHeaderField: "Authorization") // This field is fake, keep it if you want to publish to AppStore.
        request.httpMethod = "POST"
        
        let jsonData: [String: Any] = [
            "image": importedImage!.pngData()!.base64EncodedString(),
            "language": describeRequest.language.code,
            "model": describeRequest.detail.rawValue,
            "tone": describeRequest.tone.rawValue,
            "context": describeRequest.context
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonData)
        
        guard let data = try? await URLSession.shared.data(for: request).0,
              let description = String(data: data, encoding: .utf8)
        else { return "Failed to fetch the data." }
        

        return description
    }
    
    func redescribeImage() async -> String {
        return await _describeImage()
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
}
