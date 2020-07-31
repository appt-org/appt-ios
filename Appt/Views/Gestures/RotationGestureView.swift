//
//  RotationGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 31/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class RotationGestureView: GestureView {
    
    private var rotation: CGFloat!
    private var detected = false
        
    convenience init(gesture: Gesture, rotation: CGFloat) {
        self.init(gesture: gesture)
        self.rotation = rotation
        
        accessibilityTraits = .allowsDirectInteraction

        let recognizer = UIRotationGestureRecognizer(target: self, action: #selector(onRotate(_:)))
        addGestureRecognizer(recognizer)
    }

    @objc func onRotate(_ sender: UIRotationGestureRecognizer) {    
        if !detected && abs(sender.rotation) >= rotation {
            delegate?.onCorrectGesture(gesture)
            detected = true
        }
    }
}

extension RotationGestureView {
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.onIncorrectGesture()
    }
}
