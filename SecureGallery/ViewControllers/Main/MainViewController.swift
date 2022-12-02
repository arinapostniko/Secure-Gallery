//
//  MainViewController.swift
//  SecureGallery
//
//  Created by Arina Postnikova on 4.11.22.
//

import UIKit
import LocalAuthentication

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var faceIDButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)))
        
        textLabel.alpha = 0
        textField.alpha = 0
        lockButton.alpha = 0
        showButton.alpha = 0
        faceIDButton.alpha = 0

        UIView.animate(withDuration: 1, delay: 1.2, options: .curveEaseInOut, animations: {
            self.textLabel.alpha = 1
            self.textField.alpha = 1
            self.textField.placeholder = "PIN"
            self.lockButton.alpha = 1
            self.faceIDButton.alpha = 1
        }, completion: { _ in
        })

        textField.delegate = self
        lockButton.isEnabled = false
        showButton.isEnabled = false

        showButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        showButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
    }
    
    // MARK: - Private methods
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    // MARK: - Public methods
    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }

        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        view.layoutIfNeeded()
    }

    // MARK: - IBActions
    @IBAction func unlock(_ sender: Any) {
        view.endEditing(true)
        guard textField.text == "1984" else {
            textField.text = ""
            textFieldDidChangeSelection(textField)
            return
        }
        let gallery = GalleryViewController()
        let navigation = UINavigationController(rootViewController: gallery)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    @IBAction func showPin(_ sender: Any) {
        textField.isSecureTextEntry.toggle()
        showButton.isSelected = !textField.isSecureTextEntry
    }
    
    @IBAction func faceIDUnlock(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) {
            let reason = "Use Face ID"
            
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else { return }
                    let gallery = GalleryViewController()
                    let navigation = UINavigationController(rootViewController: gallery)
                    navigation.modalPresentationStyle = .fullScreen
                    self.present(navigation, animated: true)
                    self.showAlert(
                        title: "Error",
                        message: "Try again"
                    )
                }
            }
        } else {
            if let error {
                showAlert(
                    title: "No access",
                    message: "\(error.localizedDescription)"
                )
            }
        }
    }
    
}

