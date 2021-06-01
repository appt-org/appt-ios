//
//  EmailVerificationView.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 01.06.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

protocol EmailVerificationViewDelegate: AnyObject {
    func okViewAction()
}

class EmailVerificationView: UIView {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var okLabel: UILabel!
    @IBOutlet private var okView: UIView!
    @IBOutlet private var view: UIView!
    
    weak var delegate: EmailVerificationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        view.frame = self.bounds
    }
    
    private func setupUI() {
        view = Bundle.main.loadNibNamed("EmailVerificationView", owner: self, options: nil)?[0] as? UIView

        self.addSubview(view)

        titleLabel.text = "email_verification_view_title".localized
        okLabel.text = "ok".localized
        
        okView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(okViewAction)))
        
        view.layer.cornerRadius = 14.0
    }
    
    @objc private func okViewAction() {
        delegate?.okViewAction()
    }
}
