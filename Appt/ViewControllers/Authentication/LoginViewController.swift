//
//  LoginViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/11/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class LoginViewController: ViewController, UITextFieldDelegate {
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var emailTextField: AuthenticationTextField!
    @IBOutlet private var emailHintLabel: PaddingLabel!

    @IBOutlet private var passwordLabel: UILabel!
    @IBOutlet private var passwordTextField: AuthenticationTextField!

    @IBOutlet private var loginButton: PrimaryMultilineButton!
    @IBOutlet private var resetPasswordButton: MultilineButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        title = "login_vc_title".localized

        emailLabel.text = "email_label_text".localized
        emailLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)

        passwordLabel.text = "password_label_text".localized
        passwordLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)

        emailHintLabel.text = "email_textfield_hint_text".localized
        emailHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)

        emailTextField.placeholder = "email_textfield_placeholder_text".localized
        emailTextField.accessibilityLabel = emailLabel.text

        passwordTextField.placeholder = "password_textfield_placeholder_text".localized
        passwordTextField.accessibilityLabel =  passwordLabel.text
        passwordTextField.setSecureTextEntry()

        loginButton.setTitle("login_button_title".localized, for: .normal)
        resetPasswordButton.setTitle("reset_password_button_title".localized, for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        emailTextField.becomeFirstResponder()
    }
    

    @IBAction private func emailEditingChanged(_ sender: AuthenticationTextField) {
        guard let email = sender.text, let password = passwordTextField.text else {
            loginButton.isEnabled = false
            return
        }

        loginButton.isEnabled = email.isValidEmail && !password.isEmpty
    }

    @IBAction private func passwordEditingChanged(_ sender: AuthenticationTextField) {
        guard let password = sender.text, let email = emailTextField.text else {
            loginButton.isEnabled = false
            return
        }

        loginButton.isEnabled = !password.isEmpty && email.isValidEmail
    }

    @IBAction private func loginButtonPressed(_ sender: PrimaryMultilineButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        isLoading = true
        
        API.shared.login(email: email, password: password) { user, errorString in
            self.isLoading = false
            if let error = errorString {
                Alert.error(error, viewController: self)
            } else {
                self.view.endEditing(true)
                
                let viewController = UIStoryboard.main()
                if #available(iOS 13.0, *) {
                    self.navigationController?.dismiss(animated: true) {
                        UIApplication.shared.windows.first?.rootViewController = viewController
                    }
                } else {
                    let window = UIWindow()
                    window.rootViewController = viewController
                    (UIApplication.shared.delegate as? AppDelegate)?.window = window
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    @IBAction private func resetPasswordPressed(_ sender: MultilineButton) {

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.primary.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textFieldDisabled.cgColor

        guard let text = textField.text else { return }
        switch textField {
        case emailTextField:
            emailHintLabel.isHidden = text.isValidEmail || text.isEmpty
        default: break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case emailTextField:
            return string != " "
        case passwordTextField:
            return true
        default:
            return true
        }
    }
}
