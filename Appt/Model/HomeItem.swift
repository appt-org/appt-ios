//
//  HomeItem.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 27.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit
import Foundation

enum HomeItem: String {

    case training
    case meldpunt
    case community
    case overAppt
    
    case knowledgeBase
    case aanpak
    case services
    
    /** Title */
    var title: String {
        switch self {
        case .training:
            return "training_home_title".localized
        case .meldpunt:
            return "meldpunt_home_title".localized
        case .community:
            return "community_home_title".localized
        case .overAppt:
            return "over_appt_home_title".localized
        case .knowledgeBase:
            return "kennisbank_appt_home_title".localized
        case .aanpak:
            return "aanpak_home_title".localized
        case .services:
            return "services_home_title".localized
        }
    }
    
    /** Slug */
    var slug: String {
        switch self {
        case .training:
            return ""
        case .meldpunt:
            return "https://appt.nl/meldpunt"
        case .community:
            return "https://www.facebook.com/groups/1302246033296587"
        case .overAppt:
            return "https://appt.nl/over"
        case .knowledgeBase:
            return ""
        case .aanpak:
            return "https://appt.nl/kennisbank/aanpak"
        case .services:
            return ""
        }
    }
    
    /** Image */
    var image: UIImage {
        switch self {
        case .training:
            return .homeTraining
        case .meldpunt:
            return .homeMeldpunt
        case .community:
            return .homeCommunity
        case .overAppt:
            return .homeOverAppt
        case .knowledgeBase:
            return .homeKnowledgeBase
        case .aanpak:
            return .homeAanpak
        case .services:
            return .homeServices
        }
    }
}
