//
//  TapGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 28/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TapGestureView: GestureView {
    
    override func setup() {
        accessibilityTraits = .allowsDirectInteraction
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        
        if let taps = tapsRequired() {
            recognizer.numberOfTapsRequired = taps
        }
        
        if let touches = touchesRequired() {
            recognizer.numberOfTouchesRequired = touches
        }
        
        addGestureRecognizer(recognizer)
    }
    
    func tapsRequired() -> Int? {
        return nil
    }
    
    func touchesRequired() -> Int? {
        return nil
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        delegate?.onGesture(gesture)
    }
}

extension TapGestureView {
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.onInvalidGesture()
    }
}
