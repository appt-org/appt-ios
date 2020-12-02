//
//  _UIFont.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

extension UIFont {
    
    static func sourceSansPro(weight: UIFont.Weight, size: CGFloat, style: TextStyle) -> UIFont {
        if UIAccessibility.isBoldTextEnabled {
            return font(name: "SourceSansPro-Bold", size: size, style: style)
        }
        
        switch weight {
            case .regular:
                return font(name: "SourceSansPro-Regular", size: size, style: style)
            case .semibold:
                return font(name: "SourceSansPro-SemiBold", size: size, style: style)
            case .bold:
                return font(name: "SourceSansPro-Bold", size: size, style: style)
            default:
                fatalError("Font weight \(weight) not supported")
        }
    }
    
    private static func font(name: String, size: CGFloat, style: TextStyle) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
           fatalError("Font \(name) does not exist")
        }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
}
