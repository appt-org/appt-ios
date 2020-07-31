//
//  TouchGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 31/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TouchGestureView: GestureView {

    convenience init(gesture: Gesture, numberOfTaps: Int) {
        self.init(gesture: gesture)
        accessibilityTraits = .allowsDirectInteraction
    }
}

extension TouchGestureView {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.onCorrectGesture(gesture)
    }
}
