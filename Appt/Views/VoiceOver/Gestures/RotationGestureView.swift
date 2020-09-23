//
//  RotationGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 31/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class RotationGestureView: GestureView {
    
    private let fingers = 2
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
        guard !detected else {
            return
        }

        guard let rotation = rotation else { return }
        let rotated = abs(sender.rotation)
        
        guard rotated >= rotation else {
            if sender.state == .ended {
                delegate?.incorrect(gesture, feedback: "feedback_degrees".localized(rotation.degrees, rotated.degrees))
            }
            return
        }

        detected = true
        delegate?.correct(gesture)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        var feedback: String? = nil

        if let fingerCount = event?.allTouches?.count {
            if fingerCount == fingers {
                feedback = "Maak een draaibeweging in plaats van een aanraking"
            } else {
                feedback = "feedback_fingers".localized(fingers, fingerCount)
            }
        }

        delegate?.incorrect(gesture, feedback: feedback)
    }
}
