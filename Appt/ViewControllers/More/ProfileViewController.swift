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

        self.title = "my_profile_title".localized
        
        self.emailAddressTitleLabel.text = "email_label_text".localized
        self.emailAddressLabel.text = UserRegistrationData.userEmail

        self.changePasswordButton.setTitle("change_my_password_title".localized, for: .normal)
        self.logoutButton.setTitle("log_out_title".localized, for: .normal)
        self.deleteMyAccountButton.setTitle("delete_my_account_title".localized, for: .normal)
        
        self.emailAddressTitleLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .headline)
        self.emailAddressLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
    }
    
    @IBAction func changeMyPasswordButtonAction(_ sender: Any) {
        guard let viewController = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        UserRegistrationData.isUserLoggedIn = false
        UserRegistrationData.userEmail = nil
        
        self.goToAuthenticationFlow()
    }
    @IBAction func deleteMyAccountButtonAction(_ sender: Any) {
        UserRegistrationData.isUserLoggedIn = false
        UserRegistrationData.userEmail = nil
        
        self.goToAuthenticationFlow()
    }
    
    private func goToAuthenticationFlow() {
        let viewController = UIStoryboard(name: "Authentication", bundle: nil).instantiateInitialViewController()
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
    }
}
