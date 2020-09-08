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
    var view: VoiceOverView {
    switch self {
        case .headings:
            return VoiceOverHeadingsView.create(self)
        case .links:
            return VoiceOverLinksView.create(self)
        case .copyPaste:
            return VoiceOverLinksView.create(self)
        }
    }
    
    /** Completion state of the action */
    var completed: Bool {
       set {
           UserDefaults.standard.set(newValue, forKey: self.rawValue)
       }
       get {
           return UserDefaults.standard.bool(forKey: self.rawValue)
       }
    }
}
