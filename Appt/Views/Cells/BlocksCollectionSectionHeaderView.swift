//
//  BlocksCollectionSectionHeaderView.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/14/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class BlocksCollectionSectionHeaderView: UICollectionReusableView {
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

        self.titleLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        self.titleLabel.text = subject.description
        self.imgView.sd_setImage(with: subject.imgURL)
    }
    
    func setup(withTitle title: String, image: UIImage) {
        self.accessibilityLabel = title

        self.titleLabel.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
        self.titleLabel.text = title
        self.imgView.image = image
    }
}
