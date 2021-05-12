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

        self.title = "email_entry_vc_title".localized

        self.forgotPasswordLabel.text = "email_entry_forgot_password_text".localized
        self.forgotPasswordLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)

        self.descriptionLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        self.descriptionLabel.text = "email_entry_description_text".localized

        self.emailAddressLabel.text = "email_label_text".localized
        self.emailAddressLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        
        self.emailTextField.delegate = self
        self.emailTextField.placeholder = "email_textfield_placeholder_text".localized

        self.emailHintLabel.text = "email_textfield_hint_text".localized
        self.emailHintLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .body)
        
        self.continueButton.setTitle("create_new_password_button_title".localized, for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.emailTextField.becomeFirstResponder()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.primary.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textFieldDisabled.cgColor

        guard let text = textField.text else { return }

        self.emailHintLabel.isHidden = text.isValidEmail || text.isEmpty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }

    @IBAction func editingChanged(_ sender: AuthenticationTextField) {
        guard let text = sender.text, !text.isEmpty else {
            self.continueButton.isEnabled = false
            return
        }

        self.continueButton.isEnabled = text.isValidEmail
    }
}
