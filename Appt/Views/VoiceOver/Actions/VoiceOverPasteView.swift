//
//  VoiceOverPasteView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 09/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverPasteView: VoiceOverView {
    
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var textField: UITextField!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.subviews.forEach { (view) in
            if let label = view as? UILabel {
                label.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
            }
        }
        
        textField.font = .sourceSansPro(weight: .bold, size: 20, style: .body)
        textField.delegate = self
    }
}

// MARK: - VoiceOverLinksView

extension VoiceOverPasteView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 1 {
            delegate?.correct(action)
        }
        return true
    }
}
