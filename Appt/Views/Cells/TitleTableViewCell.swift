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
            // Ignored
        }
    }
    
    var taxonomy: Taxonomy? {
        didSet {
            guard let taxonomy = taxonomy else { return }

            if taxonomy.selected {
                setup(taxonomy.name, prefix: "Geselecteerd")
            } else {
                setup(taxonomy.name)
            }
        }
    }
    
    var gesture: Gesture? {
        didSet {
            guard let gesture = gesture else { return }
            
            if gesture.completed {
                setup(gesture.title, prefix: "Afgerond")
            } else {
                setup(gesture.title)
            }
        }
    }
    
    var action: Action? {
        didSet {
            guard let action = action else { return }
            
            if action.completed {
                setup(action.title, prefix: "Afgerond")
            } else {
                setup(action.title)
            }
        }
    }
    
    func setup(_ title: String, prefix: String? = nil) {
        titleLabel.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        titleLabel.text = title
        
        if let prefix = prefix {
            accessoryType = .checkmark
            accessibilityLabel = String(format: "%@. %@", prefix, title)
        } else {
            accessoryType = .disclosureIndicator
            accessibilityLabel = title
        }
    }
}
