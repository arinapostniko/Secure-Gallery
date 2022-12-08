//
//  PhotoViewController.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 4.12.22.
//

import UIKit

class PhotoViewController: UIViewController {
    
    // MARK: - Public properties
    var image = UIImage()
    
    // MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView!

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
