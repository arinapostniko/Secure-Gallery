//
//  ViewController + UIAlert.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 13.11.22.
//

import UIKit

extension ViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let dismissAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}
