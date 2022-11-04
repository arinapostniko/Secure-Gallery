//
//  ViewController.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 4.11.22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var lockButton: UIButton!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.alpha = 0
        textField.alpha = 0
        lockButton.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 1.2, options: .curveEaseInOut, animations: {
            self.textLabel.alpha = 1
            self.textField.alpha = 1
            self.textField.placeholder = "Password"
            self.lockButton.alpha = 1
        }, completion: { _ in
        })
    }

    // MARK: - IBActions
    @IBAction func unlock(_ sender: Any) {
        view.endEditing(true)
        guard textField.text == "1984" else { return }
        let gallery = GalleryViewController()
        let navigation = UINavigationController(rootViewController: gallery)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
}

