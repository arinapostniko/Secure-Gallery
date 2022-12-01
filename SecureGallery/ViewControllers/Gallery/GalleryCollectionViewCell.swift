//
//  GalleryCollectionViewCell.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 29.11.22.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    public let loadedPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setUpImageView() {
        contentView.addSubview(loadedPhotoImageView)
        loadedPhotoImageView.topAnchor.constraint(
            equalTo: contentView.topAnchor
        ).isActive = true
        loadedPhotoImageView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        loadedPhotoImageView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        loadedPhotoImageView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        ).isActive = true
    }
}
