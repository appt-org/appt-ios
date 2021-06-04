//
//  ProfileViewController.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 19.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class ProfileViewController: ViewController {
    @IBOutlet private var emailAddressTitleLabel: UILabel!
    @IBOutlet private var emailAddressLabel: UILabel!
    @IBOutlet private var changePasswordButton: MultilineButton!
    @IBOutlet private var logoutButton: SecondaryMultilineButton!
    @IBOutlet private var deleteMyAccountButton: UnderlinedMultilineButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "my_profile_title".localized
        
        emailAddressTitleLabel.text = "email_label_text".localized
        emailAddressLabel.text = UserDefaultsStorage.shared.restoreUser()?.email ?? ""

        changePasswordButton.setTitle("change_my_password_title".localized, for: .normal)
        logoutButton.setTitle("log_out_title".localized, for: .normal)
        deleteMyAccountButton.setTitle("delete_my_account_title".localized, for: .normal)
        
        emailAddressTitleLabel.font = .sourceSansPro(weight: .regular, size: 15, style: .headline)
        emailAddressLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
    }
    
    @IBAction private func changeMyPasswordButtonAction(_ sender: Any) {
        guard let user = UserDefaultsStorage.shared.restoreUser() else { return }

        self.isLoading = true

        API.shared.initiatePasswordRetrieval(email: user.email) { succeed, message in
            self.isLoading = false

            switch succeed {
            case true:
                Alert.Builder()
                    .title("change_my_password_title".localized)
                    .message(message ?? "")
                    .action("ok".localized) {
                    }
                    .present(in: self)
            case false:
                Alert.error(message ?? "", viewController: self)
            }
        }
    }
    
    @IBAction private func logoutButtonAction(_ sender: Any) {
        showLogoutAlert()
    }
    @IBAction private func deleteMyAccountButtonAction(_ sender: Any) {
        showDeleteAccountAlert()
    }
    
    private func showLogoutAlert() {
        Alert.Builder()
            .title("logout_alert_title".localized)
            .cancelAction("cancel".localized)
            .action("ok".localized) {
                self.isLoading = true
                API.shared.logout { succeed, error in
                    self.isLoading = false
                    if succeed {
                        self.goToAuthenticationFlow()
                    } else if let error = error {
                        Alert.error(error, viewController: self)
                    }
                }
            }
            .present(in: self)
    }
    
    private func showDeleteAccountAlert() {
        Alert.Builder()
            .title("delete_account_alert_title".localized)
            .cancelAction("delete_account_alert_cancel_button_text".localized)
            .action("delete_account_alert_delete_button_text".localized) {
                self.isLoading = true
                API.shared.deleteUser { succeed, error in
                    self.isLoading = false
                    if succeed {
                        self.goToAuthenticationFlow()
                    } else if let error = error {
                        Alert.error(error, viewController: self)
                    }
                }
            }
            .present(in: self)
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
