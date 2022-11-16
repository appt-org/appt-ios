//
//  Preferences.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 17/05/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit

class Preferences {
    
    static let shared = Preferences()
    
    private let defaults = UserDefaults.standard
    
    private init() {
        // Force access through shared property
    }
    
    // MARK: - URL
    
    private let KEY_URL = "url"
    
    var url: String? {
        get {
            return defaults.string(forKey: KEY_URL)
        }
        set {
            defaults.setValue(newValue, forKey: KEY_URL)
        }
    }
    
    // MARK: - URL
    
    private let KEY_ZOOM_SCALE = "zoom_scale"
    
    var zoomScale: Double {
        get {
            let value = defaults.double(forKey: KEY_ZOOM_SCALE)
            guard value > 0 else {
                return 1.0
            }
            return value
        }
        set {
            defaults.setValue(newValue, forKey: KEY_ZOOM_SCALE)
        }
    }
    
    // MARK: - Clear
    
    func clear() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
