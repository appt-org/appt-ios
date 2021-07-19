//
//  _UIFont.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

extension UIFont {
    
    static let openSansRegular = "OpenSans-Regular"
    static let openSansSemiBold = "OpenSans-SemiBold"
    static let openSansBold = "OpenSans-Bold"
    
    static func openSans(weight: UIFont.Weight, size: CGFloat, style: TextStyle, scaled: Bool = true) -> UIFont {
        if UIAccessibility.isBoldTextEnabled {
            return font(name: openSansRegular, size: size, style: style, scaled: scaled)
        }
        
        switch weight {
            case .regular:
                return font(name: openSansRegular, size: size, style: style, scaled: scaled)
            case .semibold:
                return font(name: openSansSemiBold, size: size, style: style, scaled: scaled)
            case .bold:
                return font(name: openSansBold, size: size, style: style, scaled: scaled)
            default:
                fatalError("Font weight \(weight) not supported")
        }
    }

    private static func font(name: String, size: CGFloat, style: TextStyle, scaled: Bool) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Font \(name) does not exist")
        }
        guard scaled else {
            return font
        }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
}
