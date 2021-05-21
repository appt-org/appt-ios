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
        titleLabel.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        titleLabel.text = title
        accessibilityLabel = title
    }

    func setup(_ taxonomy: Taxonomy) {
        titleLabel.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        titleLabel.text = taxonomy.name
        
        if taxonomy.selected {
            accessibilityLabel = "Geselecteerd. \(taxonomy.name)"
            accessoryType = .checkmark
        } else {
            accessibilityLabel = taxonomy.name
            accessoryType = .disclosureIndicator
        }
        
        accessibilityHint = "Dubbeltik met twee vingers om de geselecteerde filters toe te passen"
    }
    
    func setup(_ gesture: Gesture) {
        titleLabel.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        titleLabel.text = gesture.title
        
        if gesture.completed {
            accessibilityLabel = "Afgerond. \(gesture.title)"
            accessoryType = .checkmark
        } else {
            accessibilityLabel = gesture.title
            accessoryType = .disclosureIndicator
        }
    }
    
    func setup(_ action: Action) {
        titleLabel.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        titleLabel.text = action.title
        
        if action.completed {
            accessibilityLabel = "Afgerond. \(action.title)"
            accessoryType = .checkmark
        } else {
            accessibilityLabel = action.title
            accessoryType = .disclosureIndicator
        }
    }
}
