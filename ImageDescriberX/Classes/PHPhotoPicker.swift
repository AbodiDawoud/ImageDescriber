//
//  PHImagePickerController.swift
//  SwiftStarterKit



import SwiftUI
import PhotosUI


struct PHPhotoPicker: UIViewControllerRepresentable {
    var onSelect: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSelect: onSelect)
    }
    
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
        var onSelect: (UIImage) -> Void
        
        init(onSelect: @escaping (UIImage) -> Void) {
            self.onSelect = onSelect
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //Dismiss picker
            picker.dismiss(animated: true)
            guard !results.isEmpty else { return }
            
            results[0].itemProvider.loadObject(ofClass: UIImage.self) { loadedObject, _ in
                if let uiImage = loadedObject as? UIImage {
                    self.onSelect(uiImage)
                }
            }
        }
    }
}
