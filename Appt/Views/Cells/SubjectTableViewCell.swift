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

        titleLabel.text?.removeAll()
        imgView.image = nil
    }

    func setup(_ subject: Subject) {
        accessoryType = .disclosureIndicator
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = subject.title
        accessibilityLabel = subject.title
        
        loadingIndicator.startAnimating()
        imgView.sd_setImage(with: subject.imageURL) {image, _, _, _ in
            self.loadingIndicator.stopAnimating()
            
            if image != nil {
                self.imgView.image = image?.withRenderingMode(.alwaysTemplate)
                self.imgView.tintColor = .primary
            } else if image == nil {
                self.imgView.image = UIImage(named: "ic_fields_placeholder_small")
            }
        }
    }
}
