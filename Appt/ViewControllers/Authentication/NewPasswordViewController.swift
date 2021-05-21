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

        title = "new_password_vc_title".localized

        newPasswordLabel.text = "change_password_label_text".localized
        changePasswordLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)

        newPasswordLabel.text = "new_password_label_text".localized
        newPasswordLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)

        newPasswordTextField.delegate = self
        newPasswordTextField.placeholder = "new_password_textfield_placeholder_text".localized
        newPasswordTextField.setSecureTextEntry()

        passwordHintLabel.text = "new_password_textfield_hint_text".localized
        passwordHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)

        loginButton.setTitle("login_password_button_title".localized, for: .normal)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        newPasswordTextField.becomeFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.primary.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textFieldDisabled.cgColor

        guard let text = textField.text else { return }

        passwordHintLabel.isHidden = text.count >= Constants.passwordMinLength || text.isEmpty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    private func configureLoginButtonState(isDataFilledIn: Bool) {
        loginButton.isEnabled = isDataFilledIn
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        UserRegistrationData.isUserLoggedIn = true
        let viewController = UIStoryboard.main()
        if #available(iOS 13.0, *) {
            navigationController?.dismiss(animated: true) {
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
            loginButton.isEnabled = false
            return
        }

        loginButton.isEnabled = text.count >= Constants.passwordMinLength
    }
}
