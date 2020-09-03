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
}
