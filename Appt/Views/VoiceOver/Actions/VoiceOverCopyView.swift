//
//  VoiceOverCopyView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 09/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverCopyView: VoiceOverView {
    
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var textView: UITextView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.subviews.forEach { (view) in
            if let label = view as? UILabel {
                label.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
            }
        }
        
        textView.font = .sourceSansPro(weight: .bold, size: 20, style: .body)
    }
    
    override func onPasteboardChanged(_ content: String?) {
        if let content = content, textView.text.contains(content) {
            delegate?.correct(action)
        }
    }
}
