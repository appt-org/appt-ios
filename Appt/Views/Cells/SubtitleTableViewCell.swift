//
//  WebPageTableViewCell.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 06/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
        
    func setup(title: String, subtitle: String) {
        titleLabel.font = .rubik(weight: .semibold, size: 18, style: .body)
        titleLabel.text = title
        
        subtitleLabel.font = .rubik(weight: .regular, size: 14, style: .body)
        subtitleLabel.text = subtitle
        
        accessibilityLabel = title
        accessibilityValue = subtitle
        accessibilityTraits = .button
        isSelected = false
    }
    
    func setup(_ page: Page) {
        guard let title = page.title, !title.isEmpty else {
            setup(title: R.string.localizable.unknown(), subtitle: page.url)
            return
        }
        setup(title: title, subtitle: page.url)
    }
}
