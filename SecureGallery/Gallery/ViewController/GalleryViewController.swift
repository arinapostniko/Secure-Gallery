//
//  GalleryViewController.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 4.11.22.
//


import UIKit
import Kingfisher

class GalleryViewController: UIViewController {
    
    // MARK: - Public properties
    let defaultCollectionViewSpacing: CGFloat = 2
    var imagesPerLine: CGFloat = 3
    
    var images: [UIImage] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addImage: UIButton!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadImage()
        
        addImage.setTitle(NSLocalizedString("Add image", comment: ""), for: .normal)
    }
    
    // MARK: - Public methods
    func setImage(_ image: UIImage, withName name: String? = nil) {
        images.append(image)
        collectionView.reloadData()
        
        let fileName = name ?? UUID().uuidString
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        guard let data = image.pngData() else { return }
        deletePreviousImage()
        try? data.write(to: fileURL)
        UserDefaults.standard.set(fileName, forKey: "\(images.count)imageName")
        UserDefaults.standard.set(images.count, forKey: "images.count")
    }
    
    // MARK: - Private methods
    private func setupCollectionView() {
        collectionView.register(GalleryCollectionViewCell.nib(), forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
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
        let count = UserDefaults.standard.integer(forKey: "images.count")
        guard count > 0 else { return }
        for index in 1...count {
            guard let fileName = UserDefaults.standard.string(forKey: "\(index)imageName") else { continue }
            
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
            
            guard let savedData = try? Data(contentsOf: fileURL),
                  let image = UIImage(data: savedData) else { continue }
            
            images.append(image)
        }
        collectionView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { _ in
            self.showPicker(withSourceType: .camera)
        }
        let libraryAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default) { _ in
            self.showPicker(withSourceType: .photoLibrary)
        }
        let urlAction = UIAlertAction(title: NSLocalizedString("URL", comment: ""), style: .default) { _ in
            let alert = UIAlertController(
                title: NSLocalizedString("Load image", comment: ""),
                message: nil,
                preferredStyle: .alert
            )
            alert.addTextField { (textField) in
                textField.placeholder = NSLocalizedString("Enter URL", comment: "")
            }
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: { [weak alert] (_) in
                    guard let textField = alert?.textFields?[0] else { return }
                    if textField.text != nil {
                        guard let url = URL(string: textField.text ?? "") else { return }
                        let resource = ImageResource(downloadURL: url)
                        KingfisherManager.shared.retrieveImage(with: resource) { result in
                            switch result {
                            case .success(let value):
                                self.setImage(value.image)
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                    } else { return }
                    print("Text field: \(String(describing: textField.text))")
                }))
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(libraryAction)
        }
        alert.addAction(urlAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

// MARK: - UIImagePicker
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
        let alert = UIAlertController(title: NSLocalizedString("Strange", comment: ""), message: NSLocalizedString("You didn't choose any image", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
// MARK: - UICollectionView
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let destinationViewController = PhotoViewController(nibName: "PhotoViewController", bundle: nil)
        destinationViewController.image = images[index]
        destinationViewController.modalPresentationStyle = .fullScreen
        present(destinationViewController, animated: true)
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setup(with: images[index])
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (imagesPerLine - 1) * defaultCollectionViewSpacing
        let width = (collectionView.bounds.width - totalSpacing) / imagesPerLine
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultCollectionViewSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return defaultCollectionViewSpacing
    }
}
