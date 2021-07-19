//
//  ListTableTopSectionHeaderView.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 18.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class ListTableTopSectionHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private var titleLabel: UILabel!
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .header
        } set {
            // Ignored to maintain `button` trait at all times.
        }
    }
    
    func setup(_ subject: Subject) {
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .clear
        
        self.accessibilityLabel = subject.description

        self.titleLabel.font = .openSans(weight: .regular, size: 17, style: .body)
        self.titleLabel.text = subject.description
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.titleLabel.font = .openSans(weight: .regular, size: 17, style: .body)
    }
}
