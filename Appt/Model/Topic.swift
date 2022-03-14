//
//  Topic.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/09/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import Foundation

enum Topic: String {

    case source
    case contact
    
    case about
    case abra
    case sidnfonds
    
    case terms
    case privacy
    case accessibility
    
    /** Title */
    var title: String {
        switch self {
        case .about:
            return "about_title".localized
        case .contact:
            return "contact_title".localized
        case .source:
            return "source_title".localized
        
        case .abra:
            return "abra_title".localized
        case .sidnfonds:
            return "sidn_fonds_title".localized
       
        case .terms:
            return "terms_title".localized
        case .privacy:
            return "privacy_title".localized
        case .accessibility:
            return "accessibility_title".localized
        }
    }

    /** Slug */
    var slug: String {
        switch self {
        case .about:
            return "https://appt.nl/over#main"
        case .contact:
            return "https://appt.nl/contact#main"
        case .source:
            return "https://github.com/appt-org/appt-ios"
            
        case .abra:
            return "https://abra.nl"
        case .sidnfonds:
            return "https://www.sidnfonds.nl"
            
        case .terms:
            return "https://appt.nl/algemene-voorwaarden#main"
        case .privacy:
            return "https://appt.nl/privacybeleid#main"
        case .accessibility:
            return "https://appt.nl/toegankelijkheidsverklaring#main"
        }
    }

    var slugURL: URL? {
        URL(string: self.slug)
    }
    
    /** Image */
    var image: UIImage {
        switch self {
        case .source:
            return .sourceCode
        case .contact:
            return .contact
            
        case .about:
            return .appt
        case .abra:
            return .abra
        case .sidnfonds:
            return .sidnfonds
            
        case .terms:
            return .terms
        case .privacy:
            return .privacy
        case .accessibility:
            return .accessibility
        }
    }
}
