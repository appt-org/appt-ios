//
//  TapGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 28/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TapGestureView: GestureView {
    
    private var position: Position?
    
    convenience init(gesture: Gesture, numberOfTaps: Int?, numberOfFingers: Int? = nil, position: Position? = nil) {
        self.init(gesture: gesture)
        self.position = position
        
        accessibilityTraits = .allowsDirectInteraction
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        
        if let taps = numberOfTaps {
            recognizer.numberOfTapsRequired = taps
        }
        
        if let fingers = numberOfFingers {
            recognizer.numberOfTouchesRequired = fingers
        }
        
        addGestureRecognizer(recognizer)
    }

    @objc func onTap(_ sender: UITapGestureRecognizer) {
        if let position = position {
            if position.matches(recognizer: sender, view: self) {
                delegate?.correct(gesture)
            } else {
                delegate?.incorrect(gesture)
            }
        } else {
            delegate?.correct(gesture)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.incorrect(gesture)
    }
}
