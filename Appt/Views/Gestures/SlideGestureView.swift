//
//  SlideGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 17/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import AVFoundation

class SlideGestureView: GestureView {

    private var THRESHOLD:CGFloat = 50
    
    private var startLocation: CGPoint?
    private var completed = false
    
    convenience init(gesture: Gesture, fingers: Int) {
        self.init(gesture: gesture)
        accessibilityTraits = .allowsDirectInteraction
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        recognizer.numberOfTapsRequired = 1 // Means: tap once before starting long press
        addGestureRecognizer(recognizer)
    }

    // Step 1: trigger long press
    @objc func onLongPress(_ sender: UITapGestureRecognizer) {
        guard !completed else { return }
        
        let location = sender.location(in: self)
        
        if sender.state == .began {
            // Step 2: store start location
            startLocation = location
            AudioServicesPlaySystemSound(SystemSoundID(1255))
        } else if sender.state == .changed {
            // Step 3: check if dragged horizontally
            if let startLocation = startLocation, abs(location.x - startLocation.x) > THRESHOLD {
                completed = true
                delegate?.correct(gesture)
            }
        } else if !completed {
            startLocation = nil
            delegate?.incorrect(gesture)
        }
    }
            
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.incorrect(gesture)
    }
}
