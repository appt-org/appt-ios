//
//  ListTableTopSectionHeaderView.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 18.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet private var titleLabel: UILabel!
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .header
        } set {
            // Ignored to maintain `header` trait at all times.
        }
    }
    
    func setup(_ header: String) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = header
        
        accessibilityLabel = header
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
    }
}
