//
//  SwipeRightGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class SwipeRightGestureView: SwipeGestureView {
    
    override func getGesture() -> Gesture {
        return .swipeRight
    }
    
    override func getDirection() -> UISwipeGestureRecognizer.Direction {
        return .right
    }
}
