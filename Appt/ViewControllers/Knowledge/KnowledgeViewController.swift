//
//  KnowledgeViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 22/02/2021.
//  Copyright © 2021 Stichting Appt All rights reserved.
//

import UIKit

class KnowledgeViewController: SubjectsViewController {
    @IBOutlet private var emailVerificationView: EmailVerificationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllerType = .knowledgeBase
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

extension KnowledgeViewController: EmailVerificationViewDelegate {
    func okViewAction() {
        emailVerificationView.hide()
    }
}
