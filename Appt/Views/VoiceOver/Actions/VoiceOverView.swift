//
//  VoiceOverView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverView: UIView {

    convenience init(voiceOver: Bool) {
        self.init()
        
        isAccessibilityElement = true
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(elementFocusedNotification), name: UIAccessibility.elementFocusedNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverStatusDidChangeNotification), name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)
    }
    
    @objc func elementFocusedNotification() {
        print("elementFocusedNotification")
    }
    
    @objc func voiceOverStatusDidChangeNotification() {
        print("voiceOverStatusDidChangeNotification")
    }
}
