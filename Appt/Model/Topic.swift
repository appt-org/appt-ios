//
//  Topic.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

enum Topic: String {

    case terms
    case privacy
    case accessibility
    
    case source
    case sidnfonds
    
    /** Title */
    var title: String {
        switch self {
        case .terms:
            return "Algemene voorwaarden"
        case .privacy:
            return "Privacybeleid"
        case .accessibility:
            return "Toegankelijkheidsverklaring"
        case .source:
            return "Bekijk de broncode"
        case .sidnfonds:
            return "Ondersteund door het SIDN fonds"
        }
    }

    /** Slug */
    var slug: String {
        switch self {
        case .terms:
            return "algemene-voorwaarden"
        case .privacy:
            return "privacybeleid"
        case .accessibility:
            return "toegankelijkheidsverklaring"
        case .source:
            return "https://github.com/appt-nl/appt-ios"
        case .sidnfonds:
            return "https://www.sidnfonds.nl"
        }
    }
}
