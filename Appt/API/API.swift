//
//  API.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    static let shared = API()
    
    private let decoder = JSONDecoder()
    
    private lazy var headers: [String: String] = [
        "Platform": "iOS",
        "Version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    ]
    
    private init() {
        // Access through shared property
    }
    
    // MARK: - Get articles
    
    func getArticles<T: Article>(type: ArticleType, callback: @escaping ([T]?, Error?) -> ()) {
        getObject(path: "\(type.path)s?per_page=20", parameters: ["_fields": "type, id,date,title"], type: [T].self, callback: callback)
    }
    
    func getArticles<T: Article>(type: ArticleType, categories: [Category]?, tags: [Tag]?, callback: @escaping ([T]?, Error?) -> ()) {
        var parameters = ["_fields": "type,id,date,title"]
        
        if let categories = categories?.selected.ids {
            parameters["categories"] = categories.joined(separator: ",")
        }
        
        if let tags = tags?.selected.ids {
            parameters["tags"] = tags.joined(separator: ",")
        }
        
        getObject(path: "\(type.path)?per_page=20", parameters: parameters, type: [T].self, callback: callback)
    }
    
    func getArticle<T: Article>(type: ArticleType, id: Int, callback: @escaping (T?, Error?) -> ()) {
        getObject(path: "\(type.path)/\(id)", parameters: ["_fields": "type,id,date,modified,link,title,content,author,tags,categories"], type: T.self, callback: callback)
    }
    
    func getArticle<T: Article>(type: ArticleType, slug: String, callback: @escaping (T?, Error?) -> ()) {
        getObject(path: "\(type.path)?per_page=1", parameters: ["slug": slug, "_fields": "type,id,date,modified,link,title,content,author,tags,categories",], type: [T].self) { (posts, error) in
            if let post = posts?.first {
                callback(post, nil)
            } else {
                callback(nil, error)
            }
        }
    }

    // MARK: - Get categories
    
    func getCategories(callback: @escaping ([Category]?, Error?) -> ()) {
        getObject(path: "categories", parameters: ["_fields": "id,count,description,name"], type: [Category].self, callback: callback)
    }
    
    // MARK: - Get tags
       
    func getTags(callback: @escaping ([Tag]?, Error?) -> ()) {
       getObject(path: "tags", parameters: ["_fields": "id,count,description,name"], type: [Tag].self, callback: callback)
    }
    
    // MARK: - Get filters
       
    func getFilters(callback: @escaping ([Category]?, [Tag]?, Error?) -> ()) {
        getCategories { (categories, error1) in
            if let categories = categories {
                self.getTags { (tags, error2) in
                    callback(categories, tags, error2)
                }
            } else {
                callback(nil, nil, error1)
            }
        }
    }
}

// MARK: - Networking

extension API {
    
    private func postObject<T: Decodable>(path: String, data: Encodable?, type: T.Type, callback: @escaping(T?, Error?) -> ()) {
        let parameters = data?.asDictionary ?? nil
        retrieveObject(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default, type: type, callback: callback)
    }
    
    private func getObject<T: Decodable>(path: String, parameters: Parameters?, type: T.Type, callback:   @escaping(T?, Error?) -> ()) {
        retrieveObject(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default, type: type, callback: callback)
    }
    
    private func retrieveObject<T: Decodable>(path: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, type: T.Type, callback: @escaping(T?, Error?) -> ()) {
        retrieveData(path: path, method: method, parameters: parameters, encoding: encoding) { (data, error) in
            if let data = data {
              do {
                  let object = try self.decoder.decode(type.self, from: data)
                  callback(object, nil)
              } catch {
                  callback(nil, error)
              }
            } else {
                callback(nil, error)
            }
        }
    }
    
    private func retrieveData(path: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, callback: @escaping (Data?, Error?) -> ()) {
        guard let url = URL(string: Config.endpoint + path) else { return }
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: self.headers
        ).validate(statusCode: 200..<300)
         .responseJSON { (response) in
            if response.result.isSuccess, let data = response.data {
                //print("JSON", String.init(data: data, encoding: .utf8))
                callback(data, nil)
            } else if let error = response.result.error {
                callback(nil, error)
            } else {
                callback(nil, response.error)
            }
        }
    }
    
    private func download(url: URL, destination: @escaping DownloadRequest.DownloadFileDestination, callback: @escaping (URL?, Error?) -> ()) {
        Alamofire.download(url,
                           method: .get,
                           parameters: nil,
                           encoding: JSONEncoding.default,
                           headers: headers,
                           to: destination
        ).response { response in
            if response.error == nil, let filePath = response.destinationURL?.path, let url = URL(string: "file://\(filePath)") {
                callback(url, nil)
            } else {
                callback(nil, response.error)
            }
        }
    }
}
