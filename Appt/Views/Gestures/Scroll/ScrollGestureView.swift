//
//  ScrollGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 30/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class ScrollGestureView: GestureView {
    
    private var direction: UIAccessibilityScrollDirection!
    
    convenience init(gesture: Gesture, direction: UIAccessibilityScrollDirection) {
        self.init(gesture: gesture)
        self.direction = direction
    }
    
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        if self.direction == direction {
            delegate?.onGesture(gesture)
        } else {
            delegate?.onInvalidGesture()
        }
        return false
    }
}
