//
//  Action.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 02/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

enum Action: String {

    // Navigation
    case headings
    
    // Modify
    case copyPaste
    
    /** Title of the gesture */
    var title: String {
        switch self {
        case .headings:
            return "Navigeren via koppen"
        case .copyPaste:
            return "Kopiëren en plakken"
        }
    }
}
