//
//  Config.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import Foundation

class Config {
    
    static var endpoint: String = {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Missing Info.plist")
        }
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            fatalError("Unable to convert Info.plist at \(path) to NSDictionary")
        }
        guard let baseUrl = dictionary["BASE_URL"] as? String else {
            fatalError("Missing BASE_URL property in Info.plist")
        }
        return baseUrl
    }()
}
