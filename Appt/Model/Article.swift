//
//  Article.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import Foundation

enum ArticleType: String, Codable {
    case page = "page"
    case post = "post"
    case url
    
    var path: String {
        return rawValue + "s"
    }
}

class Article: Codable {
    
    var type: ArticleType
    var id: Int
    var date: String
    var modified: String?
    var title: Content
    var content: Content?
    var author: Int?
    var tags: [Int]?
    var categories: [Int]?
    var link: String?
    
    var url: URL? {
        get {
            if let link = link, var url = URL(string: link) {
                url.appendQueryItem(name: "utm_source", value: "ios")
                return url
            }
            return nil
        }
    }
        
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case date
        case modified
        case link
        case title
        case content
        case author
        case tags
        case categories
    }
}

typealias Page = Article
typealias Post = Article
