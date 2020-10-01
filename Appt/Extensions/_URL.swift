//
//  _URL.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 01/10/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return
        }

        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)

        urlComponents.queryItems = queryItems

        self = urlComponents.url!
    }
}
