//
//  ScrollRightGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 30/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class ScrollRightGestureView: ScrollGestureView {
    
    override func getGesture() -> Gesture {
        return .scrollRight
    }
    
    override func getDirection() -> UIAccessibilityScrollDirection {
        return .right
    }
}
