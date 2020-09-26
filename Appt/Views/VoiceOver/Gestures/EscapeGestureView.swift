//
//  EscapeGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 17/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class EscapeGestureView: GestureView {

    override func accessibilityPerformEscape() -> Bool {
        correct()
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        incorrect("Fout gebaar")
    }
}
