//
//  FourTapTopGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 28/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class FourTapTopGestureView: TapGestureView {
    
    override func getGesture() -> Gesture {
        return .fourFingerTapTop
    }
    
    override func touchesRequired() -> Int? {
        return 4
    }
    
    override func onTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        
        if location.y < frame.height/2 {
            delegate?.onGesture(gesture)
        }
    }
}
