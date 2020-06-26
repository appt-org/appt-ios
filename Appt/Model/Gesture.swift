//
//  Gesture.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

enum Gesture {
    case tap
    case doubleTap
    case fourFingerTapTop
    case fourFingerTapBottom
    
    private var info: (header: String, description: String) {
        switch self {
        case .tap:
            return ("Aanraken", "Selecteer onderdeel onder je vinger")
            
        case .doubleTap:
            return ("Dubbel tikken", "Hiermee activeer je het geselecteerde onderdeel")
        
        case .fourFingerTapTop:
            return ("Met vier vingers boven aan scherm tikken", "Ga naar het eerste onderdeel")
            
        case .fourFingerTapBottom:
            return ("Met vier vingers onder aan scherm tikken", "Ga naar het laatste onderdeel")
        }
    }
    
    var header: String {
        return info.header
    }
    
    var description: String {
        return info.description
    }
    
    var announcement: String {
        return String(format: "%@. %@", header, description)
    }
}
