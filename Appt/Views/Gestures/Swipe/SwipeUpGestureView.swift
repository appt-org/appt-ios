//
//  SwipeUpGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class SwipeUpGestureView: SwipeGestureView {
    
    override func getGesture() -> Gesture {
        return .swipeUp
    }
    
    override func getDirection() -> UISwipeGestureRecognizer.Direction {
        return .up
    }
}
