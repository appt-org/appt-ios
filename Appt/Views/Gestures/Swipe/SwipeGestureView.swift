//
//  SwipeGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class SwipeGestureView: GestureView {
    
    private var direction: UISwipeGestureRecognizer.Direction!
    private var numberOfFingers: Int?
    
    convenience init(gesture: Gesture, direction: UISwipeGestureRecognizer.Direction, numberOfFingers: Int? = nil) {
        self.init(gesture: gesture)
        self.direction = direction
        self.numberOfFingers = numberOfFingers
        
        accessibilityTraits = .allowsDirectInteraction
        
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        
        recognizer.direction = self.direction
        
        if let touches = numberOfFingers {
            recognizer.numberOfTouchesRequired = touches
        }
        
        addGestureRecognizer(recognizer)
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
        
        if self.direction == sender.direction {
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
