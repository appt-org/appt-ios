//
//  BlocksCollectionHeaderCell.swift
//  Appt
//
//  Created by Yurii Kozlov on 6/29/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class BlocksCollectionHeaderCell: DynamicHeightCollectionViewCell {
    @IBOutlet private var imgView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .header
        } set {
            // Ignored to maintain `button` trait at all times.
        }
    }

    func setup(_ subject: Subject) {
        self.accessibilityLabel = subject.description

        self.imgView.isHidden = true
        self.titleLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        self.titleLabel.text = subject.description
    }

    func setup(withTitle title: String, image: UIImage) {
        self.accessibilityLabel = title

        self.titleLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        self.titleLabel.text = title
        self.imgView.image = image
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.titleLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
    }

}
