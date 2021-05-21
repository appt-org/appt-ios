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
        
        title = "Appt"

        welcomeLabel.text = "welcome_text".localized
        welcomeLabel.font = .sourceSansPro(weight: .bold, size: 19, style: .headline)
        welcomeDescriptionLabel.text = "welcome_description_text".localized
        welcomeDescriptionLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        resetPasswordButton.setTitle("forgot_password".localized, for: .normal)
        createAccountButton.setTitle("create_account_text".localized, for: .normal)
        loginButton.setTitle("login_account".localized, for: .normal)
    }
}

