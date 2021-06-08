//
//  ServicesViewController.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 24.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class ServicesViewController: SubjectsViewController {
    @IBOutlet private var emailVerificationView: EmailVerificationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllerType = .services
        title = viewControllerType.title

        emailVerificationView.delegate = self

        guard let user = UserDefaultsStorage.shared.restoreUser() else { return }

        if !user.isVerified && self.navigationController?.viewControllers.count != 1 {
            emailVerificationView.hide()
        } else if user.isVerified {
            emailVerificationView.hide()
        }
    }
}

extension ServicesViewController: EmailVerificationViewDelegate {
    func okViewAction() {
        emailVerificationView.hide()
    }
}
