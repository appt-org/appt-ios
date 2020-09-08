//
//  VoiceOverLinksView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 02/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverLinksView: VoiceOverView {
    
    @IBOutlet var textView: UITextView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
//        textView.isScrollEnabled = false
//        textView.sizeToFit()
//        layoutIfNeeded()
    }
    
    override func onFocusChanged(_ elements: [UIAccessibilityElement]) {
        let count = elements.count
        
        guard count >= 3 else { return }
        
        // Check if the last three elements contain the `link` accessibility trait
        if elements.dropFirst(count-3).allSatisfy({ $0.accessibilityTraits.contains(.link) }) {
            delegate?.correct(action)
        }
    }
}
