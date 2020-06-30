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
    
    var taxonomy: Taxonomy? {
        didSet {
            if taxonomy?.selected == true {
                accessoryType = .checkmark
            } else {
                accessoryType = .none
            }
            if let title = taxonomy?.name {
                setup(title)
            }
        }
    }
    
    var gesture: Gesture? {
        didSet {
            if let action = gesture?.action {
                setup(action)
            }
        }
    }
    
    func setup(_ title: String) {
        titleLabel.text = title
        accessibilityLabel = title
    }
}
