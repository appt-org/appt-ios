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
    
    func setup(_ header: String) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = header
        
        accessibilityTraits = .header
        accessibilityLabel = header
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
    }
}
