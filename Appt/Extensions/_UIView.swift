//
//  _UIView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

extension UIView {
    static var identifier: String {
        return "\(String(describing: self))Identifier"
    }
    
    @objc func hideKeyboard() {
        endEditing(true)
        
        delay(0.1) {
            self.resignFirstResponder()
        }
    }
}
