//
//  SlideGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 17/08/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import AVFoundation

class SlideGestureView: LongPressGestureView {

    private var THRESHOLD: CGFloat = 25
    private var startLocation: CGPoint?
    
    convenience init(gesture: Gesture) {
        self.init(gesture: gesture, taps: 2, fingers: 1)
    }
    
    // Step 1: long press
    override func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if completed {
            return
        }
        
        showTouches(recognizer: sender, tapCount: sender.numberOfTapsRequired+1, longPress: true)
        
        let location = sender.location(in: self)
        
        if sender.state == .began {
            // Step 2: store start location
            startLocation = location
            AudioServicesPlaySystemSound(SystemSoundID(1255))
        } else if sender.state == .changed {
            // Step 3: check if dragged horizontally
            if let startLocation = startLocation, abs(location.x - startLocation.x) > THRESHOLD {
                correct()
            }
        } else {
            startLocation = nil
            incorrect("feedback_distance".localized(fingers))
        }
    }
}
