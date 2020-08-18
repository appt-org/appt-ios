//
//  Subject.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 23/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

enum Subject: String {
    case voiceOverEnable
    case voiceOverGestures
    case voiceOverActions
    
    var description: String {
        switch self {
        case .voiceOverEnable:
            return "VoiceOver aanzetten"
        case .voiceOverGestures:
            return "VoiceOver gebaren"
        case .voiceOverActions:
            return "VoiceOver acties"
        }
    }
}
