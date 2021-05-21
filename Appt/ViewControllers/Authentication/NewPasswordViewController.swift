//
//  NewPasswordViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/12/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class NewPasswordViewController: ViewController, UITextFieldDelegate {
    @IBOutlet var changePasswordLabel: UILabel!
    @IBOutlet var newPasswordLabel: UILabel!
    @IBOutlet var newPasswordTextField: AuthenticationTextField!
    @IBOutlet var passwordHintLabel: PaddingLabel!
    @IBOutlet var loginButton: PrimaryMultilineButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "new_password_vc_title".localized

        self.newPasswordLabel.text = "change_password_label_text".localized
        self.changePasswordLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)

        self.newPasswordLabel.text = "new_password_label_text".localized
        self.newPasswordLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)

        self.newPasswordTextField.delegate = self
        self.newPasswordTextField.placeholder = "new_password_textfield_placeholder_text".localized
        self.newPasswordTextField.setSecureTextEntry()

        self.passwordHintLabel.text = "new_password_textfield_hint_text".localized
        self.passwordHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)

        self.loginButton.setTitle("login_password_button_title".localized, for: .normal)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.newPasswordTextField.becomeFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.primary.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textFieldDisabled.cgColor

        guard let text = textField.text else { return }

        self.passwordHintLabel.isHidden = text.count >= Constants.passwordMinLength || text.isEmpty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    private func configureLoginButtonState(isDataFilledIn: Bool) {
        self.loginButton.isEnabled = isDataFilledIn
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        UserRegistrationData.isUserLoggedIn = true
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

    @IBAction func editingChanged(_ sender: AuthenticationTextField) {
        guard let text = sender.text, !text.isEmpty else {
            self.loginButton.isEnabled = false
            return
        }

        self.loginButton.isEnabled = text.count >= Constants.passwordMinLength
    }
}
