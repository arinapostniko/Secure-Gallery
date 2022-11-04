//
//  GalleryViewController.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 4.11.22.
//


import UIKit

class GalleryViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showPicker(withSourceType: .camera)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.showPicker(withSourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(libraryAction)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Public methods
    func setImage(_ image: UIImage, withName name: String? = nil) {
        imageView.image = image
        
        let fileName = name ?? UUID().uuidString
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        guard let data = image.pngData() else { return }
        deletePreviousImage()
        try? data.write(to: fileURL)
        UserDefaults.standard.set(fileName, forKey: "imageName")
    }
    
    // MARK: - Private methods
    private func showPicker(withSourceType sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = sourceType
        present(pickerController, animated: true)
    }
    
    private func deletePreviousImage() {
        guard let fileName = UserDefaults.standard.string(forKey: "imageName") else { return }
        UserDefaults.standard.removeObject(forKey: "imageName")
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    private func loadImage() {
        guard let fileName = UserDefaults.standard.string(forKey: "imageName") else { return }
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        
        guard let savedData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: savedData) else { return }
        imageView.image = image
    }
}

// MARK: - Extensions
extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        var name: String?
        if let imageName = info[.imageURL] as? URL {
            name = imageName.lastPathComponent
        }
        setImage(image, withName: name)
        self.presentedViewController?.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentedViewController?.dismiss(animated: true)
        let alert = UIAlertController(title: "Strange", message: "You didn't choose any image", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
