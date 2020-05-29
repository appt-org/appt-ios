//
//  _DispatchQueue.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

func delay(_ delay: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

func background(closure: @escaping () -> ()) {
    DispatchQueue.global(qos: .background).async {
        closure()
    }
}

func foreground(closure: @escaping () -> ()) {
    DispatchQueue.main.async {
        closure()
    }
}
