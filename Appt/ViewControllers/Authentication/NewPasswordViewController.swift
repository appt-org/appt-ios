//
//  NewPasswordViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/12/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class NewPasswordViewController: ViewController, UITextFieldDelegate {
    @IBOutlet private var changePasswordLabel: UILabel!
    @IBOutlet private var newPasswordLabel: UILabel!
    @IBOutlet private var newPasswordTextField: AuthenticationTextField!
    @IBOutlet private var passwordHintLabel: PaddingLabel!
    @IBOutlet private var changePasswordButton: PrimaryMultilineButton!

    var resetPasswordData: [String : String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "new_password_vc_title".localized

        newPasswordLabel.text = "change_password_label_text".localized
        changePasswordLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)

        newPasswordLabel.text = "new_password_label_text".localized
        newPasswordLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)

        newPasswordTextField.delegate = self
        newPasswordTextField.placeholder = "new_password_textfield_placeholder_text".localized
        newPasswordTextField.accessibilityLabel = newPasswordLabel.text
        newPasswordTextField.setSecureTextEntry()

        passwordHintLabel.text = "new_password_textfield_hint_text".localized
        passwordHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)

        changePasswordButton.setTitle("change_password_button_title".localized, for: .normal)
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
        changePasswordButton.isEnabled = isDataFilledIn
    }

    @IBAction private func changePasswordPressed(_ sender: Any) {
        self.isLoading = true

        guard let password = self.newPasswordTextField.text, let login = self.resetPasswordData["login"], let key = self.resetPasswordData["key"] else { return }

        let id = UserDefaultsStorage.shared.restoreUser()?.idString ?? ""
        let isUserLoggedIn = UserDefaultsStorage.shared.restoreUser() != nil

        API.shared.setNewPassword(login: login, id: id, password: password, key: key) { succeed, message in
            self.isLoading = false

            switch succeed {
            case true:
                Alert.Builder()
                    .title("change_password_label_text".localized)
                    .message(message ?? "")
                    .action("ok".localized) {
                        if isUserLoggedIn {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            if let loginVC = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) {
                                self.navigationController?.popToViewController(loginVC, animated: true)
                            } else {
                                self.navigationController?.popToRootViewController(animated: true)
                                let viewController = UIStoryboard.login()
                                self.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                    }
                    .present(in: self)
            case false:
                Alert.error(message ?? "", viewController: self)
            }
        }
    }

    @IBAction private  func editingChanged(_ sender: AuthenticationTextField) {
        guard let text = sender.text, !text.isEmpty else {
            changePasswordButton.isEnabled = false
            return
        }

        changePasswordButton.isEnabled = text.count >= Constants.passwordMinLength
    }
}
