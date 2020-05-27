//
//  Post.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

class Post: Codable {
    
    var id: Int
    var date: String
    var modified: String
    var link: String
    var title: Content
    var excerpt: Content
    var author: Int
    var tags: [Int]
    var categories: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case modified
        case link
        case title
        case excerpt
        case author
        case tags
        case categories
    }
}
