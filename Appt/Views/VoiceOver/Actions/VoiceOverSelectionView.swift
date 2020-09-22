//
//  VoiceOverSelectionView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 21/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverSelectionView: VoiceOverView {
    
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var textField: UITextField!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.subviews.forEach { (view) in
            if let label = view as? UILabel {
                if label.accessibilityTraits.contains(.header) {
                    label.font = .sourceSansPro(weight: .bold, size: 20, style: .body)
                } else {
                    label.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
                }
            }
        }
        
        textField.font = .sourceSansPro(weight: .bold, size: 20, style: .body)
        textField.inputView = UIView()
        textField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension VoiceOverSelectionView: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let range = textField.selectedTextRange {
            let length = textField.offset(from: range.start, to: range.end)
            
            if length > 0 {
                delegate?.correct(action)
            }
        }
    }
}
