//
//  EmailEntryViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/11/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class EmailEntryViewController: ViewController, UITextFieldDelegate {
    @IBOutlet var forgotPasswordLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var emailAddressLabel: UILabel!
    @IBOutlet var emailTextField: AuthenticationTextField!
    @IBOutlet var emailHintLabel: PaddingLabel!
    @IBOutlet var continueButton: PrimaryMultilineButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "email_entry_vc_title".localized

        forgotPasswordLabel.text = "email_entry_forgot_password_text".localized
        forgotPasswordLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)

        descriptionLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        descriptionLabel.text = "email_entry_description_text".localized

        emailAddressLabel.text = "email_label_text".localized
        emailAddressLabel.accessibilityHint = "reset_password_email_label_accessibility_hint".localized
        emailAddressLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        emailTextField.delegate = self
        emailTextField.placeholder = "email_textfield_placeholder_text".localized

        emailHintLabel.text = "email_textfield_hint_text".localized
        emailHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)
        
        continueButton.setTitle("create_new_password_button_title".localized, for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        emailTextField.becomeFirstResponder()
    }
    
    @IBAction private func continueButtonPressed(_ sender: Any) {
        guard let email = self.emailTextField.text else { return }

        self.isLoading = true

        API.shared.initiatePasswordRetrieval(email: email) { succeed, message in
            self.isLoading = false

            switch succeed {
            case true:
                Alert.Builder()
                    .title("email_entry_vc_title".localized)
                    .message(message ?? "")
                    .action("ok".localized) {
                        self.navigationController?.popViewController(animated: true)
                    }
                    .present(in: self)
            case false:
                Alert.error(message ?? "", viewController: self)
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.primary.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textFieldDisabled.cgColor

        guard let text = textField.text else { return }

        emailHintLabel.isHidden = text.isValidEmail || text.isEmpty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }

    @IBAction private func editingChanged(_ sender: AuthenticationTextField) {
        guard let text = sender.text, !text.isEmpty else {
            continueButton.isEnabled = false
            return
        }

        continueButton.isEnabled = text.isValidEmail
    }
}
