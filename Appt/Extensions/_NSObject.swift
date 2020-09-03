//
//  _NSObject.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

extension NSObject {
    public var className: String {
        return NSStringFromClass(type(of: self))
    }
}
