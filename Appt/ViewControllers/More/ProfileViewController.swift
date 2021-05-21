//
//  ProfileViewController.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 19.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private var emailAddressTitleLabel: UILabel!
    @IBOutlet private var emailAddressLabel: UILabel!
    @IBOutlet private var changePasswordButton: MultilineButton!
    @IBOutlet private var logoutButton: SecondaryMultilineButton!
    @IBOutlet private var deleteMyAccountButton: UnderlinedMultilineButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "my_profile_title".localized
        
        emailAddressTitleLabel.text = "email_label_text".localized
        emailAddressLabel.text = UserRegistrationData.userEmail

        changePasswordButton.setTitle("change_my_password_title".localized, for: .normal)
        logoutButton.setTitle("log_out_title".localized, for: .normal)
        deleteMyAccountButton.setTitle("delete_my_account_title".localized, for: .normal)
        
        emailAddressTitleLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .headline)
        emailAddressLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
    }
    
    @IBAction private func changeMyPasswordButtonAction(_ sender: Any) {
        let viewController = UIStoryboard.newPassword()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func logoutButtonAction(_ sender: Any) {
        UserRegistrationData.isUserLoggedIn = false
        UserRegistrationData.userEmail = nil
        
        goToAuthenticationFlow()
    }
    @IBAction private func deleteMyAccountButtonAction(_ sender: Any) {
        UserRegistrationData.isUserLoggedIn = false
        UserRegistrationData.userEmail = nil
        
        goToAuthenticationFlow()
    }
    
    private func goToAuthenticationFlow() {
        let viewController = UIStoryboard.welcome()
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
}
