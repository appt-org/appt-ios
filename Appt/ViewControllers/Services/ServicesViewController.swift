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
            hideVerificationView()
        } else if user.isVerified {
            hideVerificationView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserDefaultsStorage.shared.restoreUser()?.isVerified == true {
            self.hideVerificationView()
        }
    }

    private func hideVerificationView() {
        NSLayoutConstraint(item: emailVerificationView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0).isActive = true
    }
}

extension ServicesViewController: EmailVerificationViewDelegate {
    func okViewAction() {
        hideVerificationView()
    }
}
