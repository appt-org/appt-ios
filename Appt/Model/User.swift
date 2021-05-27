//
//  User.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 25.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import Foundation

class UserMeta: Codable {
    private var verificationStateArray: Array<String>
    
    var verificationState: Bool {
        if verificationStateArray.isEmpty {
            return false
        } else {
            return verificationStateArray[0] == "1" ? true : false
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case verificationStateArray = "user_activation_status"
    }
}

class User: Codable {
    var id: Int
    var username: String
    var email: String
    var userMeta: UserMeta
        
    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case userMeta = "user_meta"
    }
}

