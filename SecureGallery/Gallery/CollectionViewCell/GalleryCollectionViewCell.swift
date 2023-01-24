//
//  GalleryCollectionViewCell.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 2.12.22.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    static let identifier = "GalleryCollectionViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Override methods
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    // MARK: - Public methods
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func setup(with image: UIImage) {
        imageView.image = image
    }
}
