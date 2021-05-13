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
    @IBOutlet private var createAccountButton: PrimaryMultilineButton!
    @IBOutlet private var loginButton: SecondaryMultilineButton!
    @IBOutlet private var resetPasswordButton: MultilineButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Appt"

        self.welcomeLabel.text = "welcome_text".localized
        self.welcomeLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)
        self.welcomeDescriptionLabel.text = "welcome_description_text".localized
        self.welcomeDescriptionLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        self.resetPasswordButton.setTitle("forgot_password".localized, for: .normal)
        self.createAccountButton.setTitle("create_account_text".localized, for: .normal)
        self.loginButton.setTitle("login_account".localized, for: .normal)
    }
}

