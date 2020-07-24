//
//  SwipeDownGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class SwipeDownGestureView: SwipeGestureView {
    
    override func getGesture() -> Gesture {
        return .swipeDown
    }
    
    override func getDirection() -> UISwipeGestureRecognizer.Direction {
        return .down
    }
}
