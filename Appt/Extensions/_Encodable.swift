//
//  _Encodable.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

extension Encodable {
    var asDictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
            return [:]
        }
        return dictionary
    }
}
