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
    
    /** Title */
    var title: String {
        switch self {
        case .terms:
            return "Algemene voorwaarden"
        case .privacy:
            return "Privacybeleid"
        case .accessibility:
            return "Toegankelijkheidsverklaring"
        }
    }

    /* Slug */
    var slug: String {
        switch self {
        case .terms:
            return "algemene-voorwaarden"
        case .privacy:
            return "privacybeleid"
        case .accessibility:
            return "toegankelijkheidsverklaring"
        }
    }
}
