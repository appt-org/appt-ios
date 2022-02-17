//
//  SubjectCollectionViewCell.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/13/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit
import SDWebImage

final class SubjectCollectionViewCell: DynamicHeightCollectionViewCell {
    
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
                    background.backgroundColor = UIColor.background
                } else {
                    background.backgroundColor = UIColor.white
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 20
        layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            layer.borderColor = UIColor.separator.cgColor
        } else {
            layer.borderColor = UIColor.lightGray.cgColor
        }
        
        categoryLabel.textColor = .foreground
        categoryLabel.adjustsFontForContentSizeCategory = true
        
        if #available(iOS 13.0, *) {
            background.backgroundColor = UIColor.background
        } else {
            background.backgroundColor = UIColor.white
        }
        
        isAccessibilityElement = true
        shouldGroupAccessibilityChildren = true
    }

    func setup(_ subject: Subject) {
        categoryLabel.text = subject.title
        accessibilityLabel = subject.title

        categoryLabel.font = .openSans(weight: .regular, size: 17, style: .body)

        loadingIndicator.startAnimating()
        imgView.sd_setImage(with: subject.imgURL) { image, _, _, _ in
            self.loadingIndicator.stopAnimating()
            if image == nil {
                self.imgView.image = UIImage.blocksPlaceholder
            }
        }
    }
    
    func setup(withTitle title: String, image: UIImage) {
        categoryLabel.text = title
        accessibilityLabel = title

        categoryLabel.font = .openSans(weight: .semibold, size: 17, style: .body)

        imgView.image = image
    }
}
