//
//  Storage.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 26.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import Foundation

class UserDefaultsStorage {
    enum Keys: String {
        case user
    }
    
    static let shared = UserDefaultsStorage()
    
    private let defaults = UserDefaults.standard
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    
    func storeUser(_ user: User?) throws {
        if user == nil {
            defaults.set(nil, forKey: Keys.user.rawValue)
        } else {
            do {
                let encoded = try encoder.encode(user)
                defaults.set(encoded, forKey: Keys.user.rawValue)
            } catch {
                throw error
            }
        }
    }
    
    func restoreUser() -> User? {
        if let userData = defaults.object(forKey: Keys.user.rawValue) as? Data,
           let user = try? decoder.decode(User.self, from: userData) {
            return user
        }
        
        return nil
    }
}
