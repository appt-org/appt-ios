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

extension KnowledgeViewController: EmailVerificationViewDelegate {
    func okViewAction() {
        hideVerificationView()
    }
}
