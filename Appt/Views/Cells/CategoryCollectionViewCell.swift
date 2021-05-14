//
//  CategoryCollectionViewCell.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/13/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var background: UIView!
    @IBOutlet private var imgView: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .button
        } set {
            // Ignored to maintain `button` trait at all times.
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.background.layer.cornerRadius = 20
        self.background.backgroundColor = .background
        self.categoryLabel.textColor = .foreground
        self.categoryLabel.font = .sourceSansPro(weight: .semibold, size: 17, style: .body)
    }

    func setup(_ subject: Subject) {
        self.categoryLabel.text = subject.title
        self.accessibilityLabel = subject.title

        self.imgView.sd_setImage(with: subject.imgURL)
    }
}
