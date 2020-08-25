//
//  DefaultGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 18/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import AVKit

class DefaultGestureView: LongPressGestureView {

    private var THRESHOLD = 25
    
    private var completed = false
    private var count = 0
    
    convenience init(gesture: Gesture) {
        self.init(gesture: gesture, numberOfTaps: 1, numberOfFingers: 1, minimumDuration: 2.0)
    }
    
    override func onLongPress(_ sender: UILongPressGestureRecognizer) {
        guard !completed else { return }
        
        if sender.state == .began {
            // Step 1: double tap long press
            AudioServicesPlaySystemSound(SystemSoundID(1255))
        } else if sender.state == .changed {
            // Step 2: make any gesture
            count += 1
            
            if count > THRESHOLD {
                completed = true
                delegate?.correct(gesture)
            }
        } else if sender.state == .ended {
            count = 0
        }
    }
}
