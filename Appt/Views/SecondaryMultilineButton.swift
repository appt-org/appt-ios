//
//  SecondaryMultilineButton.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/26/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class SecondaryMultilineButton: MultilineButton {
    override func commonInit() {
        super.commonInit()

        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.foreground.cgColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                self.layer.borderColor = UIColor.foreground.cgColor
            }
        }
    }
}
