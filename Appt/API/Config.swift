//
//  Config.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import Foundation

class Config {
    private static var infoPlistDictionary: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Missing Info.plist")
        }
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            fatalError("Unable to convert Info.plist at \(path) to NSDictionary")
        }
        
        return dictionary
    }()
    
    private static var baseUrl: String = {
        guard let baseUrl = infoPlistDictionary["BASE_URL"] as? String else {
            fatalError("Missing BASE_URL property in Info.plist")
        }
        return baseUrl
    }()
    
    static var endpoint: String = {
        guard let baseApiPath = infoPlistDictionary["BASE_API_PATH"] as? String else {
            fatalError("Missing BASE_API_PATH property in Info.plist")
        }
        return baseUrl + baseApiPath
    }()
    
    static var contentEndpoint: String = {
        guard let baseApiPath = infoPlistDictionary["BASE_CONTENT_PATH"] as? String else {
            fatalError("Missing BASE_CONTENT_PATH property in Info.plist")
        }
        return baseUrl + baseApiPath
    }()

    // MARK: - Credentials

    private static var credentialsPlistDictionary: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Credentials", ofType: "plist") else {
            fatalError("Missing Credentials.plist")
        }
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            fatalError("Unable to convert Credentials.plist at \(path) to NSDictionary")
        }

        return dictionary
    }()

    static var authorizationKey: String {
        guard let authorizationKey = self.credentialsPlistDictionary["Authorization key Live"] as? String else {
            fatalError("Unable to get value for key: Authorization key Live from Credentials.plist")
        }

        return authorizationKey
    }
}
