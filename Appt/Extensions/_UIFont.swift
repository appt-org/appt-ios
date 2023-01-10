//
//  _UIFont.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import RswiftResources

extension UIFont {

    static func rubik(weight: UIFont.Weight, size: CGFloat, style: TextStyle = .body, scaled: Bool = true, maxSize: CGFloat = 100) -> UIFont {
        if UIAccessibility.isBoldTextEnabled {
            return font(R.font.rubikBold, size: size, style: style, scaled: scaled, maxSize: maxSize)
        }
        
        switch weight {
            case .regular:
                return font(R.font.rubikRegular, size: size, style: style, scaled: scaled, maxSize: maxSize)
            case .semibold:
                return font(R.font.rubikSemiBold, size: size, style: style, scaled: scaled, maxSize: maxSize)
            case .bold:
                return font(R.font.rubikBold, size: size, style: style, scaled: scaled, maxSize: maxSize)
            default:
                fatalError("Font weight \(weight) not supported")
        }
    }

    private static func font(_ resource: FontResource, size: CGFloat, style: TextStyle, scaled: Bool, maxSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: resource.name, size: size) else {
            fatalError("Font \(resource) does not exist")
        }
        guard scaled else {
            return font
        }
        let scaledFont = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        guard scaledFont.pointSize < maxSize else {
            return scaledFont.withSize(maxSize)
        }
        return scaledFont
    }
}
