//
//  API.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import Foundation
import Alamofire

class API {
    enum ContentType {
        case knowledgeBase
        case services
        
        var path: String {
            switch self {
            case .knowledgeBase:
                return "knowledgeBase.json"
            case .services:
                return "services.json"
            }
        }
    }
    
    static let shared = API()
    
    private let decoder = JSONDecoder()
    
    private lazy var defaultHeaders: [String: String] = [
        "Platform": "iOS",
        "Version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    ]
    
    private lazy var superUserHeaders: [String: String] = [
        "Authorization": "Basic Ym9kaWExOTk0c2h2QGdtYWlsLmNvbTprYlNrSkdeeUlFTURTUUUmNygyS152MVQ="
    ]
    
    private init() {
        // Access through shared property
    }
    
    // MARK: - Get articles
    
    func getArticles<T: Article>(type: ArticleType, parameters: [String: Any], callback: @escaping (Response<[T]>) -> ()) {
        getObject(path: "\(type.path)?per_page=20", parameters: parameters, type: [T].self, callback: callback)
    }
    
    func getArticles<T: Article>(type: ArticleType, page: Int = 1, categories: [Category]? = nil, tags: [Tag]? = nil, parentId: Int? = nil, slug: String? = nil, callback: @escaping (Response<[T]>) -> ()) {
        var parameters: [String: Any] = [
            "_fields": "type,id,date,title,link",
            "page": page
        ]
    
        if let categoryIDs = categories?.selected.ids {
            parameters["categories"] = categoryIDs.joined(separator: ",")
        }
        
        if let tagIDs = tags?.selected.ids {
            parameters["tags"] = tagIDs.joined(separator: ",")
        }
        
        if let parentId = parentId {
            parameters["parent"] = parentId
        }
        
        if let slug = slug {
            parameters["slug"] = slug
        }
        
        if type == .page {
            parameters["orderby"] = "title"
            parameters["order"] = "asc"
        } else if type == .post {
            parameters["orderby"] = "date"
            parameters["order"] = "desc"
        }
       
        getObject(path: "\(type.path)?per_page=20", parameters: parameters, type: [T].self, callback: callback)
    }
    
    func getArticle<T: Article>(type: ArticleType, id: Int, callback: @escaping (Response<T>) -> ()) {
        getObject(path: "\(type.path)/\(id)", parameters: ["_fields": "type,id,date,modified,link,title,content,author,tags,categories"], type: T.self, callback: callback)
    }
    
    func getArticle<T: Article>(type: ArticleType, slug: String, callback: @escaping (Response<T>) -> ()) {
        getObject(
            path: "\(type.path)?per_page=1", parameters: ["slug": slug, "_fields": "type,id,date,modified,link,title,content,author,tags,categories"], type: [T].self) { (response) in
            if let article = response.result?.first {
                callback(Response(result: article, total: response.total, pages: response.pages, error: response.error))
            } else {
                callback(Response(error: response.error))
            }
        }
    }
    
    func getArticle<T: Article>(type: ArticleType, url: URL, callback: @escaping (Response<T>) -> ()) {
        getArticles(type: type, slug: url.lastPathComponent) { (response) in
            if let articles = response.result {
                let matches = articles.filter { $0.link?.contains(url.absoluteString) ?? false }
                
                if let article = matches.first {
                    return self.getArticle(type: article.type, id: article.id, callback: callback)
                } else {
                    callback(Response(error: response.error))
                }
            } else {
                callback(Response(error: response.error))
            }
        }
    }

    // MARK: - Get categories
    
    func getCategories(callback: @escaping (Response<[Category]>) -> ()) {
        getObject(path: "categories", parameters: ["_fields": "id,count,description,name"], type: [Category].self, callback: callback)
    }
    
    // MARK: - Get tags
       
    func getTags(callback: @escaping (Response<[Tag]>) -> ()) {
       getObject(path: "tags", parameters: ["_fields": "id,count,description,name"], type: [Tag].self, callback: callback)
    }
    
    // MARK: - Get filters
       
    func getFilters(callback: @escaping ([Category]?, [Tag]?, Error?) -> ()) {
        getCategories { (response1) in
            if let categories = response1.result {
                self.getTags { (response2) in
                    if let tags = response2.result {
                        callback(categories, tags, nil)
                    } else {
                        callback(nil, nil, response2.error)
                    }
                }
            } else {
                callback(nil, nil, response1.error)
            }
        }
    }
    
    // MARK: - User requests
    func login(email: String, password: String, callback: @escaping (User?, String?) -> ()) {
        userRequest(path: "login", method: .post, parameters: ["username": email, "password": password], headers: nil, encoding: JSONEncoding.default) { response in

            if response.error != nil, response.data == nil {
                callback(nil, response.error?.localizedDescription)
            } else if response.error != nil, let responseData = response.data {
                let errorData = String(data: responseData, encoding: .utf8)
                callback(nil, errorData)
            } else if let data = response.data, response.error == nil {
                do {
                    let user = try self.decoder.decode(User.self, from: data)
                    try UserDefaultsStorage.shared.storeUser(user)
                    callback(user, nil)
                } catch {
                    callback(nil, error.localizedDescription)
                }
            } else {
                callback(nil, nil)
            }
        }
    }
    
    func logout(callback: @escaping (Bool, String?) -> ()) {
        guard let user = UserDefaultsStorage.shared.restoreUser() else {
            callback(false, nil)
            return
        }
        userRequest(path: "logout", method: .get, parameters: ["id": user.id], headers: nil, encoding: URLEncoding.default) { response in
            if let error = response.error {
                try? UserDefaultsStorage.shared.storeUser(nil)
                callback(false, error.localizedDescription)
            } else {
                do {
                    try UserDefaultsStorage.shared.storeUser(nil)
                    callback(true, nil)
                } catch {
                    callback(false, error.localizedDescription)
                }
            }
        }
    }
    
    func createUser(username: String, email: String, password: String, userRolesIds: [String], callback: @escaping (User?, String?) -> ()) {
        userRequest(path: "users", method: .post, parameters: ["username": username, "email": email, "password": password, "roles": userRolesIds.joined(separator: ",")], headers: superUserHeaders, encoding: JSONEncoding.default) { response in
            
            if response.error != nil {
                callback(nil, response.error?.localizedDescription)
            } else if let data = response.data {
                do {
                    let user = try self.decoder.decode(User.self, from: data)
                    try UserDefaultsStorage.shared.storeUser(user)
                    callback(user, nil)
                } catch {
                    callback(nil, error.localizedDescription)
                }
            } else {
                callback(nil, nil)
            }
        }
    }

    func initiatePasswordRetrieval(email: String, callback: @escaping (Bool, String?) -> ()) {
        userRequest(path: "1/user/retrieve_password", method: .get, parameters: ["user_login": email], headers: superUserHeaders, encoding: URLEncoding.queryString) { response in
            if let error = response.error {
                callback(false, error.localizedDescription)
            } else if let data = response.data {
                do {
                    let json = try self.decoder.decode([String: String].self, from: data)
                    let message = json["msg"] ?? ""
                    callback(true, message)
                } catch {
                    callback(false, error.localizedDescription)
                }
            } else {
                callback(false, nil)
            }
        }
    }

    func setNewPassword(login: String, id: String?, password: String, key: String, callback: @escaping (Bool, String?) -> ()) {
        userRequest(path: "change-password", method: .post, parameters: ["login": login, "id": id ?? "", "key": key, "new_password": password], headers: superUserHeaders, encoding: JSONEncoding.default) { response in
            if let error = response.error {
                callback(false, error.localizedDescription)
            } else if let data = response.data {
                do {
                    let responseMessage = try self.decoder.decode(String.self, from: data)
                    callback(true, responseMessage)
                } catch {
                    callback(false, error.localizedDescription)
                }
            } else {
                callback(false, nil)
            }
        }
    }
    
    func getUser(callback: @escaping (User?, String?) -> ()) {
        guard let user = UserDefaultsStorage.shared.restoreUser() else {
            callback(nil, nil)
            return
        }
        
        userRequest(path: "users/\(user.id)", method: .get, parameters: ["context":"edit"], headers: superUserHeaders, encoding: URLEncoding.default) { response in
            if response.error != nil, response.data == nil {
                callback(nil, response.error?.localizedDescription)
            } else if response.error != nil, let responseData = response.data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                    let jsonErrorMsg = jsonResponse?["message"] as? String
                    callback(nil, jsonErrorMsg ?? response.error?.localizedDescription)
                } catch {
                    callback(nil, error.localizedDescription)
                }
            } else if let data = response.data {
                do {
                    let user = try self.decoder.decode(User.self, from: data)
                    try UserDefaultsStorage.shared.storeUser(user)
                    callback(user, nil)
                } catch {
                    callback(nil, error.localizedDescription)
                }
            } else {
                callback(nil, nil)
            }
        }
    }
    
    func deleteUser(callback: @escaping (Bool, String?) -> ()) {
        guard let user = UserDefaultsStorage.shared.restoreUser() else {
            callback(false, nil)
            return
        }
        
        userRequest(path: "users/\(user.id)", method: .delete, parameters: ["reassign": "", "force": "true"], headers: superUserHeaders, encoding: URLEncoding.queryString) { response in
            if response.error != nil, response.data == nil {
                callback(false, response.error?.localizedDescription)
            } else if response.error != nil, let responseData = response.data {
                let json = try? self.decoder.decode([String: String].self, from: responseData)
                let message = json?["message"]
                callback(false, message ?? response.error?.localizedDescription)
            } else {
                try? UserDefaultsStorage.shared.storeUser(nil)
                callback(true, nil)
            }
        }
    }
    
    // MARK: - Get content
    
    func getKnowledgeBase(_ callback: @escaping(Subject?, String?) -> ()) {
        getContent(type: .knowledgeBase, callback: callback)
    }
    
    func getServices(_ callback: @escaping(Subject?, String?) -> ()) {
        getContent(type: .services, callback: callback)
    }
}

// MARK: - Networking

extension API {
    private func postObject<T: Decodable>(path: String, data: Encodable?, headers: [String: String]?, type: T.Type, callback: @escaping(Response<T>) -> ()) {
        let parameters = data?.asDictionary ?? nil
        postObject(path: path, parameters: parameters, headers: headers, type: type, callback: callback)
    }
    
    private func postObject<T: Decodable>(path: String, parameters: [String: Any]?, headers: [String: String]?, type: T.Type, callback: @escaping(Response<T>) -> ()) {
        retrieveObject(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default, type: type, callback: callback)
    }
    
    private func getObject<T: Decodable>(path: String, parameters: Parameters?, type: T.Type, callback:   @escaping(Response<T>) -> ()) {
        retrieveObject(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default, type: type, callback: callback)
    }
    
    private func retrieveObject<T: Decodable>(path: String, method: HTTPMethod, parameters: Parameters?, headers: [String: String]? = nil, encoding: ParameterEncoding, type: T.Type, callback: @escaping(Response<T>) -> ()) {
        guard let url = URL(string: Config.endpoint + path) else { return }
        
        let allHeaders = defaultHeaders.merging(headers ?? [:]) { (_, new) in new }
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: allHeaders
        ).validate(statusCode: 200..<300)
         .responseJSON { (response) in
            let response = Response<T>(response)
            callback(response)
        }
    }
    
    private func userRequest(path: String, method: HTTPMethod, parameters: Parameters?, headers: [String: String]? = nil, encoding: ParameterEncoding, callback: @escaping((DataResponse<Any>) -> ())) {
        guard let url = URL(string: Config.endpoint + path) else { return }
        
        let allHeaders = defaultHeaders.merging(headers ?? [:]) { (_, new) in new }
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: allHeaders
        ).validate(statusCode: 200..<300)
        .responseJSON { (response) in
            callback(response)
        }
    }
    
    private func getContent(type: ContentType, callback: @escaping(Subject?, String?) -> ()) {
        guard let url = URL(string: Config.contentEndpoint + type.path) else { return }
        
        URLCache.shared.removeAllCachedResponses()
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: nil
        ).validate(statusCode: 200..<300)
        .response { (response) in
            if response.error != nil {
                callback(nil, response.error?.localizedDescription)
            } else if let data = response.data {
                do {
                    let subject = try self.decoder.decode(Subject.self, from: data)
                    callback(subject, nil)
                } catch {
                    callback(nil, error.localizedDescription)
                }
            }
        }
    }
}
