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

        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

        self.title = "login_vc_title".localized

        self.emailLabel.text = "email_label_text".localized
        self.emailLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)

        self.passwordLabel.text = "password_label_text".localized
        self.passwordLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)

        self.emailHintLabel.text = "email_textfield_hint_text".localized
        self.emailHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)

        self.emailTextField.placeholder = "email_textfield_placeholder_text".localized

        self.passwordTextField.placeholder = "password_textfield_placeholder_text".localized
        self.passwordTextField.setSecureTextEntry()

        self.loginButton.setTitle("login_button_title".localized, for: .normal)
        self.resetPasswordButton.setTitle("reset_password_button_title".localized, for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.emailTextField.becomeFirstResponder()
    }
    

    @IBAction func emailEditingChanged(_ sender: AuthenticationTextField) {
        guard let email = sender.text, let password = self.passwordTextField.text else {
            self.loginButton.isEnabled = false
            return
        }

        self.loginButton.isEnabled = email.isValidEmail && !password.isEmpty
    }

    @IBAction func passwordEditingChanged(_ sender: AuthenticationTextField) {
        guard let password = sender.text, let email = self.emailTextField.text else {
            self.loginButton.isEnabled = false
            return
        }

        self.loginButton.isEnabled = !password.isEmpty && email.isValidEmail
    }

    @IBAction func loginButtonPressed(_ sender: PrimaryMultilineButton) {
        UserRegistrationData.isUserLoggedIn = true
        UserRegistrationData.userEmail = self.emailTextField.text
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
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
    @IBAction func resetPasswordPressed(_ sender: MultilineButton) {

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.primary.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textFieldDisabled.cgColor

        guard let text = textField.text else { return }
        switch textField {
        case self.emailTextField:
            self.emailHintLabel.isHidden = text.isValidEmail || text.isEmpty
        default: break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField === self.passwordTextField {
            self.passwordTextField.resignFirstResponder()
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
