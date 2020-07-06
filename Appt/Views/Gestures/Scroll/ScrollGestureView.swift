//
//  ScrollGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 30/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class ScrollGestureView: GestureView {
    
    override func setup() {
        // None
    }
    
    func getDirection() -> UIAccessibilityScrollDirection {
        fatalError("getDirection() should be overridden")
    }
    
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        if direction == getDirection() {
            delegate?.onGesture(gesture)
        } else {
            delegate?.onInvalidGesture()
        }
        return false
    }
}
