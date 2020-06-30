//
//  DoubleTapGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 28/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class DoubleTapGestureView: TapGestureView {
    
    override func getGesture() -> Gesture {
        return .doubleTap
    }
    
    override func tapsRequired() -> Int? {
        return 2
    }
}
