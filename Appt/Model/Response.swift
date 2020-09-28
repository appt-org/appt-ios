//
//  Response.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 28/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation
import Alamofire

class Response<T: Decodable> {
    
    var result: T?
    var total: Int?
    var pages: Int?
    
    var error: Error?
    
    init(result: T? = nil, total: Int? = nil, pages: Int? = nil, error: Error? = nil) {
        self.result = result
        self.total = total
        self.pages = pages
        self.error = error
    }
    
    convenience init(_ response: DataResponse<Any>) {
        if response.result.isSuccess, let data = response.data {
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                
                var total: Int? = nil
                var pages: Int? = nil
                
                if let headers = response.response?.allHeaderFields {
                    if let totalString = headers["x-wp-total"] as? String {
                        total = Int(totalString)
                    }
                    if let pagesString = headers["x-wp-totalpages"] as? String {
                        pages = Int(pagesString)
                    }
                }
                
                self.init(result: result, total: total, pages: pages, error: nil)
            } catch {
                self.init(error: error)
            }
        } else if let error = response.result.error {
            self.init(error: error)
        } else {
            self.init(error: response.error)
        }
    }
}
