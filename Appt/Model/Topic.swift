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
            return "privacy_title".localized
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
            return UIImage(named: "ic_my_profile")!
            
        case .source:
            return UIImage(named: "ic_source")!
        case .sidnfonds:
            return UIImage(named: "ic_sidnfonds")!
        case .contact:
            return UIImage(named: "ic_contact")!
            
        case .privacy:
            return UIImage(named: "ic_privacy")!
        case .accessibility:
            return UIImage(named: "ic_accessibility")!
        case .terms:
            return UIImage(named: "ic_terms")!
        }
    }
}
