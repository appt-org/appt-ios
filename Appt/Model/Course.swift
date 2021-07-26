//
//  Course.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 23/07/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import Foundation

enum Course: String {
    case voiceOverEnable
    case voiceOverGestures
    case voiceOverActions
    
    /** Title */
    var title: String {
        switch self {
        case .voiceOverGestures:
            return "1. VoiceOver gebaren"
        case .voiceOverEnable:
            return "2. VoiceOver aanzetten"
        case .voiceOverActions:
            return "3. VoiceOver acties"
        }
    }
}
