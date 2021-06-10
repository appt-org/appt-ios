//
//  CategoryCollectionViewCell.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/13/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit
import SDWebImage

final class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var background: UIView!
    @IBOutlet private var imgView: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .button
        } set {
            // Ignored to maintain `button` trait at all times.
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                if #available(iOS 13.0, *) {
                    background.backgroundColor = UIColor.separator
                } else {
                    background.backgroundColor = UIColor.lightGray
                }
            } else {
                if #available(iOS 13.0, *) {
                    background.backgroundColor = UIColor.categoryCellBackground
                } else {
                    background.backgroundColor = UIColor.white
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.background.layer.cornerRadius = 20
        self.categoryLabel.textColor = .foreground
        self.categoryLabel.adjustsFontForContentSizeCategory = true
        self.isAccessibilityElement = true
        
        if #available(iOS 13.0, *) {
            background.backgroundColor = UIColor.categoryCellBackground
        } else {
            background.backgroundColor = UIColor.white
        }
    }

    func setup(_ subject: Subject) {
        self.categoryLabel.text = subject.title
        self.accessibilityLabel = subject.title

        self.categoryLabel.font = .sourceSansPro(weight: .semibold, size: 17, style: .body)

        self.loadingIndicator.startAnimating()

        self.imgView.sd_setImage(with: subject.imgURL) {image, _, _, _ in
            self.loadingIndicator.stopAnimating()
            if image == nil {
                self.imgView.image = UIImage.blocksPlaceholder
            }
        }
    }
    
    func setup(withTitle title: String, image: UIImage) {
        self.categoryLabel.text = title
        self.accessibilityLabel = title

        self.categoryLabel.font = .sourceSansPro(weight: .semibold, size: 17, style: .body)

        self.imgView.image = image
    }
}
