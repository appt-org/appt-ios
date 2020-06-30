//
//  SingleTapGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class SingleTapGestureView: TapGestureView {
    
    override func getGesture() -> Gesture {
        return .singleTap
    }
    
    override func tapsRequired() -> Int? {
        return 1
    }
}
