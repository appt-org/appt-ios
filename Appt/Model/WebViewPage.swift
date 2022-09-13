//
//  WebViewPage.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 07/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import Foundation

class WebViewPage: Page {
    
    var url: String
    var title: String?
    
    init(url: String, title: String?) {
        self.url = url
        self.title = title
    }
}
