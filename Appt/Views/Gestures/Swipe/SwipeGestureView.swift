//
//  SwipeGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class SwipeGestureView: GestureView {
    
    override func setup() {
        accessibilityTraits = .allowsDirectInteraction
        
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        recognizer.direction = getDirection()
        addGestureRecognizer(recognizer)
    }
    
    func getDirection() -> UISwipeGestureRecognizer.Direction {
        fatalError("getDirection() should be overridden")
    }
    
    @objc func onSwipe(_ sender: UISwipeGestureRecognizer) {
        print("onSwipe", sender.direction)
        
        switch sender.direction {
        case .down: print("Down swipe")
        case .right: print("Right swipe")
        case .left: print("Left swipe")
        case .up: print("Up swipe")
        default: print ("Unknown direction")
        }
        
        if sender.direction == getDirection() {
            delegate?.onGesture(gesture)
        } else {
            delegate?.onInvalidGesture()
        }
    }
}

extension SwipeGestureView {
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("onTouchesEnded")
        delegate?.onInvalidGesture()
    }
}
