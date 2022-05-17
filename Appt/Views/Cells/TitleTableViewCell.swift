//
//  TitleCell.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    
    override open var accessibilityTraits: UIAccessibilityTraits {
        get {
            if self.isSelected {
                return [.button, .selected]
            } else {
                return .button
            }
        } set {
            // Ignored to maintain `button` trait at all times.
        }
    }
    
    func setup(_ title: String) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = title
        
        accessibilityLabel = title
        isSelected = false
    }
}
