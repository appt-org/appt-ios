//
//  Label.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/01/2026.
//  Copyright © 2026 Stichting Appt. All rights reserved.
//

import UIKit

class ApptLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        adjustsFontForContentSizeCategory = true
        lineBreakMode = .byCharWrapping
        numberOfLines = 0
        minimumScaleFactor = 0.5
    }
}
