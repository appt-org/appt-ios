//
//  SubjectTableViewCell.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/14/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit
import SDWebImage

final class SubjectTableViewCell: UITableViewCell {
    
    @IBOutlet private var imgView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .button
        } set {
            // Ignored to maintain `button` trait at all times.
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel.text?.removeAll()
        self.imgView.image = nil
    }

    func setup(_ subject: Subject) {
        self.accessoryType = .disclosureIndicator
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = subject.title
        accessibilityLabel = subject.title
        
        self.loadingIndicator.startAnimating()
        self.imgView.sd_setImage(with: subject.imgURL) {image, _, _, _ in
            self.loadingIndicator.stopAnimating()
            
            if image != nil {
                self.imgView.image = image?.withRenderingMode(.alwaysTemplate)
                self.imgView.tintColor = .primary
            } else if image == nil {
                self.imgView.image = UIImage.listPlaceholder
            }
        }
    }
}
