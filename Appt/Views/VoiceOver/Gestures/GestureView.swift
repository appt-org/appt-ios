//
//  GestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

protocol GestureViewDelegate {
    func correct(_ gesture: Gesture)
    func incorrect(_ gesture: Gesture, feedback: String)
}

class GestureView: UIView {
    
    var delegate: GestureViewDelegate?
    var gesture: Gesture!
    var completed = false
    
    convenience init(gesture: Gesture) {
        self.init()
        self.gesture = gesture
        
        isAccessibilityElement = true
        isMultipleTouchEnabled = true
        accessibilityTraits = .allowsDirectInteraction
        accessibilityLabel = gesture.description
    }
    
    func correct() {
        if !completed {
            completed = true
            delegate?.correct(gesture)
        }
    }
    
    func incorrect(_ feedback: String) {
        if !completed {
            delegate?.incorrect(gesture, feedback: feedback)
        }
    }
    
    override func accessibilityPerformEscape() -> Bool {
        // This gesture is ignored to avoid unwanted behaviour.
        return true
    }
    
    override func accessibilityPerformMagicTap() -> Bool {
        // This gesture is ignored to avoid unwanted behaviour.
        return true
    }
}
