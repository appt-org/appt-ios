//
//  WelcomeViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/26/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class WelcomeViewController: ViewController {
    @IBOutlet private var welcomeLabel: UILabel!
    @IBOutlet private var welcomeDescriptionLabel: UILabel!
    @IBOutlet private var createAccountButton: MultilineTitleButton!
    @IBOutlet private var loginButton: MultilineTitleButton!
    @IBOutlet private var resetPasswordButton: MultilineTitleButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.welcomeLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)
        self.welcomeDescriptionLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)

        self.createAccountButton.setDynamicFontSize(font: .sourceSansPro(weight: .semibold, size: 17, style: .body))
        self.loginButton.setDynamicFontSize(font: .sourceSansPro(weight: .semibold, size: 17, style: .body))
        self.resetPasswordButton.setDynamicFontSize(font: .sourceSansPro(weight: .semibold, size: 17, style: .body))

        self.createAccountButton.layer.cornerRadius = 17
        self.loginButton.layer.cornerRadius = 17
        self.loginButton.layer.borderWidth = 2
        self.loginButton.layer.borderColor = UIColor.foreground.cgColor

        self.welcomeLabel.text = "welcome_text".localized
        self.welcomeDescriptionLabel.text = "welcome_description_text".localized
        self.createAccountButton.setTitle("create_account_text".localized, for: .normal)
        self.loginButton.setTitle("login_account".localized, for: .normal)
        self.resetPasswordButton.setTitle("forgot_password".localized, for: .normal)

        self.title = "Appt"
    }

    @IBAction func createButtonPressed(_ sender: UIButton) {
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }

    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                self.loginButton.layer.borderColor = UIColor.foreground.cgColor
            }
        }
    }
}

