//
//  _UITouch.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 22/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

extension Set where Element == UITouch {
    var maxTapCount: Int? {
        return map { $0.tapCount }.max()
    }
}
