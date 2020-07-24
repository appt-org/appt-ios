//
//  TapGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 28/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TapGestureView: GestureView {
    
    private var numberOfTaps: Int?
    private var numberOfFingers: Int?
    private var position: Position?
    
    convenience init(gesture: Gesture, numberOfTaps: Int?, numberOfFingers: Int? = nil, position: Position? = nil) {
        self.init(gesture: gesture)
        self.numberOfTaps = numberOfTaps
        self.numberOfFingers = numberOfFingers
        self.position = position
        
        accessibilityTraits = .allowsDirectInteraction
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        
        if let taps = numberOfTaps {
            recognizer.numberOfTapsRequired = taps
        }
        
        if let touches = numberOfFingers {
            recognizer.numberOfTouchesRequired = touches
        }
        
        addGestureRecognizer(recognizer)
    }

    @objc func onTap(_ sender: UITapGestureRecognizer) {
        if let position = position {
            if position.matches(recognizer: sender, view: self) {
                delegate?.onCorrectGesture(gesture)
            } else {
                delegate?.onIncorrectGesture()
            }
        } else {
            delegate?.onCorrectGesture(gesture)
        }
    }
}

extension TapGestureView {
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.onIncorrectGesture()
    }
}
