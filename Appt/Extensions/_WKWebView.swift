//
//  _UIWebView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 16/11/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import WebKit

extension WKWebView {
    
    var zoomScale: Double {
        get {
            guard let scale = value(forKey: "viewScale") as? Double else {
                return 1.0
            }
            return scale
        }
        set {
            setValue(newValue, forKey: "viewScale")
        }
    }
}
