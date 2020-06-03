//
//  API.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation
import Alamofire

@objc class API: NSObject {
    
    @objc static let shared = API()
    
    private let decoder = JSONDecoder()
    
    private lazy var headers: [String: String] = [
        "Platform": "iOS",
        "Version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    ]
    
    // MARK: - Get posts
    
    func getPosts(callback: @escaping ([Post]?, Error?) -> ()) {
        getObject(path: "posts?per_page=10", parameters: ["_fields": "id,date,title"], type: [Post].self, callback: callback)
    }
    
    // MARK: - Get post
    
    func getPost(id: Int, callback: @escaping (Post?, Error?) -> ()) {
        getObject(path: "posts/\(id)", parameters: ["_fields": "id,date,modified,link,title,content,author,tags,categories"], type: Post.self, callback: callback)
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
        
        print("Retrieve JSON:", url.absoluteString)
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: self.headers
        ).validate(statusCode: 200..<300)
         .responseJSON { (response) in
            if response.result.isSuccess, let data = response.data {
                print("JSON", String.init(data: data, encoding: .utf8))
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
