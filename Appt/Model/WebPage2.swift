//
//  WebPage.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 02/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import Foundation
import WebKit

class WebPage2 {
    
    private static var suffix: String = {
        return R.string.localizable.appt_suffix()
    }()
    
    var url: String
    var title: String
    
    init(url: String, title: String?) {
        self.url = url
        if let title = title, !title.isEmpty {
            self.title = title.replacingOccurrences(of: WebPage2.suffix, with: "", options: [.regularExpression])
        } else {
            self.title = R.string.localizable.unknown()
        }
    }
    
    convenience init(item: WKBackForwardListItem) {
        self.init(url: item.url.absoluteString, title: item.title)
    }
    
    convenience init(item: VisitedPage) {
        self.init(url: item.url ?? "", title: item.title)
    }
    
    convenience init(item: BookmarkedPage) {
        self.init(url: item.url ?? "", title: item.title)
    }
}
