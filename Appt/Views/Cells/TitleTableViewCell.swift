//
//  TitleCell.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    func setup(_ title: String) {
        titleLabel.font = .rubik(weight: .regular, size: 18, style: .body)
        titleLabel.text = title
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0
        
        accessibilityLabel = title
        accessibilityTraits = .button
    }
}
