//
//  ViewControllerDelegate.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 10.11.22.
//

import UIKit

extension MainViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 4 {
            textField.text?.removeLast()
        }
        
        lockButton.isEnabled = textField.text?.count ?? 0 == 4
        showButton.isEnabled = textField.text?.count ?? 0 > 0
        
        if textField.text?.count ?? 0 > 0 {
            showButton.alpha = 1
        }
        
        if textField.text?.count ?? 0 == 0 {
            showButton.alpha = 0
        }
    }
}
