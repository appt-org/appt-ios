//
//  HeaderCollectionViewCell.swift
//  Appt
//
//  Created by Yurii Kozlov on 6/29/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class HeaderCollectionViewCell: DynamicHeightCollectionViewCell {
    
    @IBOutlet private var titleLabel: UILabel!

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .header
        } set {
            // Ignored to maintain `header` trait at all times.
        }
    }

    func setup(_ subject: Subject) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = subject.description
        
        accessibilityLabel = subject.description
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
    }
}
