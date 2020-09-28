//
//  TitleCell.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    
    override open var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .button
        } set {
            // Ignored to maintain `button` trait at all times.
        }
    }
    
    var title: String? {
        didSet {
            guard let title = title else { return }
            
            titleLabel.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
            titleLabel.text = title
            accessibilityLabel = title
        }
    }
    
    var taxonomy: Taxonomy? {
        didSet {
            guard let taxonomy = taxonomy else { return }
            
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
    }
    
    var gesture: Gesture? {
        didSet {
            guard let gesture = gesture else { return }
            
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
    }
    
    var action: Action? {
        didSet {
            guard let action = action else { return }
            
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
}
