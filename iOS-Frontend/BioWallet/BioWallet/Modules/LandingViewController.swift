//
//  LandingViewController.swift
//  BioWallet
//
//  Created by Alok Sahay on 15.04.2023.
//

import Foundation
import LocalAuthentication
import UIKit

class LandingViewController : BaseViewController {
    
    @IBOutlet weak var authImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passcodeTextField: UITextField!
    
    private let passcodeLength = 8
    private var passcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBiometricAuthentication()
        passcodeTextField.delegate = self
    }
}

extension LandingViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.titleLabel.text = ""
        checkPasscodeValidity(passcodeString: textField.text)
    }
    
}

extension LandingViewController {
    
    func checkBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometric authentication is available
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in with your passkey or biometric authentication.") { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.checkPasscodeAuthentication()
                    } else {
                        self?.titleLabel.text = "Biometric authentication failed"
                    }
                }
            }
        } else {
            titleLabel.text = "Biometric authentication not approved"
        }
    }
    
    func checkPasscodeAuthentication() {
        titleLabel.text = "Enter 8 digit passcode"
        UIView.animate(withDuration: 0.5, animations: {
            self.authImageView.alpha = 0.0
        })
    }
    
    func checkPasscodeValidity(passcodeString: String?) {
        guard let passcodeString = passcodeString else {
            return
        }
        
        if passcodeString.count < passcodeLength {
            titleLabel.text = passcodeString
        } else if passcodeString.count == passcodeLength {
            if validatePasscode(passcode) {
                // Take appropriate action when passcode is correct
            } else {
                // Show error message and reset passcode
                titleLabel.text = "Incorrect passcode"
                passcode = ""
            }
        }
    }
    
    private func validatePasscode(_ passcode: String) -> Bool {
        // Validate the passcode here and return true if it is correct
        return passcode == KeyManager.sharedKeyManager.retrievePasskey()
    }
}
