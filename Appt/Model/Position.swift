//
//  Position.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

enum Position {

    case top
    case bottom

    var name: String {
        if self == .top {
            return "position_top".localized
        } else {
            return "position_bottom".localized
        }
    }
        
    public static func from(recognizer: UIGestureRecognizer, view: UIView) -> Position {
        let location = recognizer.location(in: view)
        
        if location.y < (view.frame.height / 2) {
            return .top
        } else {
            return .bottom
        }
    }
}
