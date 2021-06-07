//
//  RegistrationViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/28/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class RegistrationViewController: ViewController, UITextFieldDelegate {
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var emailTextField: AuthenticationTextField!
    @IBOutlet private var emailHintLabel: UILabel!
    
    @IBOutlet private var passwordLabel: UILabel!
    @IBOutlet private var passwordTextField: AuthenticationTextField!
    @IBOutlet private var passwordHintLabel: UILabel!
    
    @IBOutlet private var privacyPolicyLabel: UILabel!
    @IBOutlet private var privacyPolicySwitch: UISwitch!
    @IBOutlet private var privacyPolicyButton: UnderlinedMultilineButton!

    @IBOutlet private var termsAndConditionsLabel: UILabel!
    @IBOutlet private var termsAndConditionsSwitch: UISwitch!
    @IBOutlet private var termsAndConditionsButton: UnderlinedMultilineButton!

    @IBOutlet private var registerButton: PrimaryMultilineButton!
    @IBOutlet private var registerButtonBottonConstraint: NSLayoutConstraint!

    var userRoles: Set<Role> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "account_creation_vc_title".localized
        
        emailLabel.text = "email_label_text".localized
        emailLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        emailTextField.delegate = self
        emailTextField.placeholder = "email_textfield_placeholder_text".localized

        passwordTextField.delegate = self
        passwordTextField.placeholder = "password_textfield_placeholder_text".localized
        
        emailHintLabel.text = "email_textfield_hint_text".localized
        emailHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)
        
        passwordLabel.text = "password_label_text".localized
        passwordLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        passwordHintLabel.text = "password_textfield_hint_text".localized
        passwordHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)
        
        privacyPolicyLabel.text = "privacy_policy_label_text".localized
        privacyPolicyLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        privacyPolicyButton.setTitle(Topic.privacy.title, for: .normal)
        privacyPolicyButton.underline()
        
        termsAndConditionsLabel.text = "terms_and_conditions_label_text".localized
        termsAndConditionsLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        termsAndConditionsButton.setTitle(Topic.terms.title, for: .normal)
        termsAndConditionsButton.underline()
        
        registerButton.setTitle("complete_registration_button_title_text".localized, for: .normal)
        registerButton.setTitle("complete_registration_button_title_text".localized, for: .disabled)
        
        passwordTextField.setSecureTextEntry()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        emailTextField.becomeFirstResponder()
    }

    override func keyboardWillShow(frame: CGRect, notification: Notification) {
        super.keyboardWillShow(frame: frame, notification: notification)

        self.animateWithKeyboard(notification: notification) { keyboardSize in
            self.registerButtonBottonConstraint.constant = keyboardSize.height - self.view.safeAreaInsets.bottom
        }
    }

    override func keyboardWillHide(notification: Notification) {
        super.keyboardWillHide(notification: notification)

        self.animateWithKeyboard(notification: notification) { keyboardSize in
            self.registerButtonBottonConstraint.constant = 0
        }
    }

    private var isRegistrationDataFilledIn: Bool {
        emailTextField.text?.isValidEmail ?? false && passwordTextField.text?.isValidPassword(numberOfSymbols: Constants.passwordMinLength) ?? false && privacyPolicySwitch.isOn && termsAndConditionsSwitch.isOn
    }

    @IBAction private  func emailEditingChanged(_ sender: AuthenticationTextField) {
        guard let email = sender.text, let password = passwordTextField.text else {
            registerButton.isEnabled = false
            return
        }

        let canRegister = email.isValidEmail && password.count >= Constants.passwordMinLength && privacyPolicySwitch.isOn && termsAndConditionsSwitch.isOn

        registerButton.isEnabled = canRegister
    }

    @IBAction private func passwordEditingChanged(_ sender: AuthenticationTextField) {
        guard let password = sender.text, let email = emailTextField.text else {
            registerButton.isEnabled = false
            return
        }

        let canRegister = email.isValidEmail && password.count >= Constants.passwordMinLength && privacyPolicySwitch.isOn && termsAndConditionsSwitch.isOn

        registerButton.isEnabled = canRegister
    }
    @IBAction private func registerButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        let username = String(email.prefix(while: { $0 != "@" }))
        
        isLoading = true
        
        API.shared.createUser(username: username, email: email, password: password, userRolesIds: userRoles.map { $0.id }) { user, errorString in
            self.isLoading = false
            if let error = errorString {
                Alert.error(error, viewController: self)
            } else {
                self.showConfirmationAlert()
            }
        }
    }


    @IBAction private func privacyPolicyValueChanged(_ sender: UISwitch) {
        registerButton.isEnabled = isRegistrationDataFilledIn
    }

    @IBAction private func termsAndConditionsValueChanged(_ sender: UISwitch) {
        registerButton.isEnabled = isRegistrationDataFilledIn
    }

    @IBAction func showTermsAndConditions(_ sender: Any) {
        let articleViewController = UIStoryboard.article(type: .page, slug: Topic.terms.slug)
        navigationController?.pushViewController(articleViewController, animated: true)
    }

    @IBAction func showPrivacyPolicy(_ sender: Any) {
        let articleViewController = UIStoryboard.article(type: .page, slug: Topic.privacy.slug)
        navigationController?.pushViewController(articleViewController, animated: true)
    }

    private func showConfirmationAlert() {
        Alert.Builder()
            .title("confirmation_alert_title".localized)
            .message("confirmation_alert_message".localized)
            .action("ok".localized) {
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
            }.present(in: self)
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
        case passwordTextField:
            passwordHintLabel.isHidden = text.isValidPassword(numberOfSymbols: Constants.passwordMinLength) || text.isEmpty
        default: break
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}

