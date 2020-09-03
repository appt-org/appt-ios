//
//  Action.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 02/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

enum Action: String {

    // Navigation
    case headings
    case links
    
    // Modify
    case copyPaste
    
    /** Title of the action */
    var title: String {
        switch self {
        case .headings:
            return "Navigeren via koppen"
        case .links:
            return "Navigeren via links"
        case .copyPaste:
            return "Kopiëren en plakken"
        }
    }
    
    /* View for the action */
    
    var view: UIView {
    switch self {
        case .headings:
            return VoiceOverHeadingsView.fromNib()
        case .links:
            return VoiceOverLinksView.fromNib()
        case .copyPaste:
            return VoiceOverLinksView.fromNib()
        }
    }
}
