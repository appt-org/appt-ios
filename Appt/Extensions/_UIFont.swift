//
//  _UIFont.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

extension UIFont {
    
    @objc static func sourceSansPro(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        switch weight {
            case .regular:
                return font(name: "SourceSansPro", size: size)
            case .semibold:
                return font(name: "SourceSansPro-SemiBold", size: size)
            case .bold:
                return font(name: "SourceSansPro-Bold", size: size)
            default:
                fatalError("Font weight \(weight) not supported")
        }
    }
    
    private static func font(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
           fatalError("Font \(name) deos not exist")
        }
        return font
    }
}
