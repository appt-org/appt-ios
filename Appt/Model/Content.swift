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
    
    private enum CodingKeys: String, CodingKey {
        case rendered
    }
}
