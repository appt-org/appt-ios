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

    private var isRegistrationDataFilledIn: Bool {
        self.emailTextField.text?.isValidEmail == true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

        self.title = "login_vc_title".localized
        self.emailLabel.text = "email_label_text".localized
        self.passwordLabel.text = "password_label_text".localized

        self.emailHintLabel.text = "email_textfield_hint_text".localized
        self.emailHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)

        self.emailTextField.placeholder = "email_textfield_placeholder_text".localized

        self.passwordTextField.placeholder = "password_textfield_placeholder_text".localized
        self.passwordTextField.setSecureTextEntry()

        self.loginButton.setTitle("login_button_title".localized, for: .normal)
        self.resetPasswordButton.setTitle("reset_password_button_title".localized, for: .normal)
    }

    @IBAction func loginButtonPressed(_ sender: PrimaryMultilineButton) {

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

        self.configureRegisterButtonState(isDataFilledIn: self.isRegistrationDataFilledIn)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField === self.passwordTextField {
            self.passwordTextField.resignFirstResponder()
        }
        return true
    }

    private func configureRegisterButtonState(isDataFilledIn: Bool) {
        self.loginButton.isEnabled = isDataFilledIn
    }

}
