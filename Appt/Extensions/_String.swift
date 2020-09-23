//
//  _String.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string

        return decoded ?? self
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "Localized")
    }
    
    func localized(_ arguments: CVarArg...) -> String {
        //String.localizedStringWithFormat(NSLocalizedString("feedback_fingers", comment: ""), fingers, fingerCount)
        return String(format: self.localized, locale: .current, arguments: arguments)
    }
}
