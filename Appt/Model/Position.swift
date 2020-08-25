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

    func matches(recognizer: UIGestureRecognizer, view: UIView) -> Bool {
        let location = recognizer.location(in: view)
        
        switch self {
        case .top:
            return location.y < view.frame.height / 2
        case .bottom:
            return location.y > view.frame.height / 2
        }
    }
}
