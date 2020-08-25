//
//  LongPressGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 18/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import AVFoundation

class LongPressGestureView: GestureView {

    convenience init(gesture: Gesture, numberOfTaps: Int?, numberOfFingers: Int? = nil, minimumDuration: Double? = nil) {
        self.init(gesture: gesture)
        accessibilityTraits = .allowsDirectInteraction
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        
        if let taps = numberOfTaps {
            recognizer.numberOfTapsRequired = taps
        }
        
        if let fingers = numberOfFingers {
            recognizer.numberOfTouchesRequired = fingers
        }
        
        if let duration = minimumDuration {
            recognizer.minimumPressDuration = duration
        }
        
        addGestureRecognizer(recognizer)
    }

    @objc func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.correct(gesture)
        }
    }
            
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.incorrect(gesture)
    }
}
