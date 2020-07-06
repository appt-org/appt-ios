//
//  ScrollUpGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 30/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class ScrollUpGestureView: ScrollGestureView {
    
    override func getGesture() -> Gesture {
        return .scrollUp
    }
    
    override func getDirection() -> UIAccessibilityScrollDirection {
        return .up
    }
}

