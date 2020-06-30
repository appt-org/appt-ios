//
//  Gesture.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

enum Gesture {
    case singleTap
    case doubleTap
    case fourFingerTapTop
    case fourFingerTapBottom
    
    private var info: (action: String, description: String) {
        switch self {
        case .singleTap:
            return ("Een onderdeel selecteren en uitspreken", "Tik met één vinger op het scherm om een onderdeel te selecteren")
            
        case .doubleTap:
            return ("Het geselecteerde onderdeel activeren", "Dubbeltik met één vinger op het scherm om het geselecteerde onderdeel te activeren")
        
        case .fourFingerTapTop:
            return ("Naar het eerste onderdeel gaan", "Tik met vier vingers bovenaan het scherm, om naar het eerste onderdeel te gaan")
            
        case .fourFingerTapBottom:
            return ("Naar het laatste onderdeel gaan", "Tik met vier vingers onderaan het scherm, om naar het laatste onderdeel te gaan")
        }
    }
    
    var action: String {
        return info.action
    }
    
    var description: String {
        return info.description
    }
}
