//
//  Content.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

class Content: Codable {
    
    var rendered: String
    
    private var _decoded: String? = nil
    var decoded: String {
        get {
            if let decoded = _decoded {
                return decoded
            } else {
                let decoded = rendered.htmlDecoded
                self._decoded = decoded
                return decoded
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case rendered
    }
}
