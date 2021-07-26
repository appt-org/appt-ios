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

    func setup(_ taxonomy: Taxonomy) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = taxonomy.name

        accessibilityLabel = taxonomy.name
        isSelected = taxonomy.selected
        accessoryType = isSelected ? .checkmark : .disclosureIndicator

        accessibilityHint = "Dubbeltik met twee vingers om de geselecteerde filters toe te passen"
    }
    
    func setup(_ gesture: Gesture) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = gesture.title
        
        accessibilityLabel = gesture.title
        accessibilityValue = gesture.completed ? "Afgerond" : nil
        accessoryType = gesture.completed ? .checkmark : .disclosureIndicator
        accessibilityHint = "Dubbeltik met twee vingers om dit gebaar te oefenen"
    }
    
    func setup(_ action: Action) {
        titleLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        titleLabel.text = action.title
        
        accessibilityLabel = action.title
        accessibilityValue = action.completed ? "Afgerond" : nil
        accessoryType = action.completed ? .checkmark : .disclosureIndicator
        accessibilityHint = "Dubbeltik met twee vingers om deze actie te oefenen"
    }
}
