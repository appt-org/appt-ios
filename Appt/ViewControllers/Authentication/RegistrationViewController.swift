//
//  RegistrationViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/28/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class RegistrationViewController: ViewController, UITextFieldDelegate {
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var emailTextField: AuthenticationTextField!
    @IBOutlet private var emailHintLabel: UILabel!
    
    @IBOutlet private var passwordLabel: UILabel!
    @IBOutlet private var passwordTextField: AuthenticationTextField!
    @IBOutlet private var passwordHintLabel: UILabel!
    
    @IBOutlet private var privacyPolicyLabel: UILabel!
    @IBOutlet private var privacyPolicySwitch: UISwitch!
    
    @IBOutlet private var termsAndConditionsLabel: UILabel!
    @IBOutlet private var termsAndConditionsSwitch: UISwitch!
    
    @IBOutlet private var registerButton: PrimaryMultilineButton!
    
    private var isRegistrationDataFilledIn: Bool {
        self.emailTextField.text?.isValidEmail ?? false && self.passwordTextField.text?.isValidPassword(numberOfSymbols: Constants.passwordMinLength) ?? false && self.privacyPolicySwitch.isOn && self.termsAndConditionsSwitch.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "account_creation_vc_title".localized
        
        self.descriptionLabel.text = "registration_vc_description_text".localized
        self.descriptionLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        self.emailLabel.text = "email_label_text".localized
        self.emailLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        self.emailTextField.delegate = self
        self.emailTextField.placeholder = "email_textfield_placeholder_text".localized

        self.passwordTextField.delegate = self
        self.passwordTextField.placeholder = "password_textfield_placeholder_text".localized
        
        self.emailHintLabel.text = "email_textfield_hint_text".localized
        self.emailHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)
        
        self.passwordLabel.text = "password_label_text".localized
        self.passwordLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        self.passwordHintLabel.text = "password_textfield_hint_text".localized
        self.passwordHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)
        
        self.privacyPolicyLabel.text = "privacy_policy_label_text".localized
        self.privacyPolicyLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        self.termsAndConditionsLabel.text = "terms_and_conditions_label_text".localized
        self.termsAndConditionsLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        self.registerButton.setTitle("complete_registration_button_title_text".localized, for: .normal)
        self.registerButton.setTitle("complete_registration_button_title_text".localized, for: .disabled)
        
        self.passwordTextField.setSecureTextEntry()
        
    }
    
    private func configureRegisterButtonState(isDataFilledIn: Bool) {
        self.registerButton.isEnabled = isDataFilledIn
    }
    
    @IBAction private func registerButtonPressed(_ sender: Any) {
        self.showConfirmationAlert()
    }
    
    @IBAction private func privacyPolicyValueChanged(_ sender: UISwitch) {
        self.configureRegisterButtonState(isDataFilledIn: self.isRegistrationDataFilledIn)
    }
    
    @IBAction private func termsAndConditionsValueChanged(_ sender: UISwitch) {
        self.configureRegisterButtonState(isDataFilledIn: self.isRegistrationDataFilledIn)
    }

    private func showConfirmationAlert() {
        Alert.Builder()
            .title("confirmation_alert_title".localized)
            .message("confirmation_alert_message".localized)
            .action("ok".localized) {
                debugPrint("Ok button pressed")
            }.present(in: self)
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
        case self.passwordTextField:
            self.passwordHintLabel.isHidden = text.isValidPassword(numberOfSymbols: Constants.passwordMinLength) || text.isEmpty
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
}
