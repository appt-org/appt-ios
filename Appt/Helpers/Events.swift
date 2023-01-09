//
//  Events.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 01/10/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import Foundation
import FirebaseAnalytics

class Events {
    
    // MARK: - Event
    
    enum Category: String {
        case error
        case url
    }
    
    public static func log(_ category: Category, identifier: String, value: Int? = nil) {
        print("Log event, category: \(category), identifier: \(identifier), value: \(value)")
        
        var parameters: [String: Any] = [
            AnalyticsParameterItemID: identifier
        ]
        
        if let value = value {
            parameters[AnalyticsParameterValue] = value
        }
        
        Analytics.logEvent(category.rawValue, parameters: parameters)
    }
    
    public static func log(_ category: Category, object: Any) {
        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
            if let identifier = String(data: data, encoding: .utf8) {
                Events.log(category, identifier: identifier)
            }
        } catch let error {
            print("Error logging object: \(object) -> \(error)")
        }
    }
}
