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

    case myprofile
    
    case source
    case sidnfonds
    case contact
    
    case privacy
    case accessibility
    case terms
    
    /** Title */
    var title: String {
        switch self {
        case .myprofile:
            return "my_profile_title".localized
        
        case .source:
            return "source_title".localized
        case .sidnfonds:
            return "sidn_fonds_title".localized
        case .contact:
            return "contact_title".localized
        case .privacy:
            return "privacy_title".localized
        case .accessibility:
            return "accessability_title".localized
        case .terms:
            return "terms_title".localized
        }
    }

    /** Slug */
    var slug: String {
        switch self {
        case .myprofile:
            return ""
            
        case .source:
            return "https://github.com/appt-nl/appt-ios"
        case .sidnfonds:
            return "https://www.sidnfonds.nl"
        case .contact:
            return "https://appt.nl/contact"
            
        case .privacy:
            return "privacybeleid"
        case .accessibility:
            return "toegankelijkheidsverklaring"
        case .terms:
            return "algemene-voorwaarden"
        }
    }
    
    /** Image */
    var image: UIImage {
        switch self {
        case .myprofile:
            return .myprofile
            
        case .source:
            return .sourceCode
        case .sidnfonds:
            return .sidnfonds
        case .contact:
            return .contact
            
        case .privacy:
            return .privacy
        case .accessibility:
            return .accessibility
        case .terms:
            return .terms
        }
    }
}
