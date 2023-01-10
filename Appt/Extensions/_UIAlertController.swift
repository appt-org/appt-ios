//
//  _UIAlertController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 05/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func addItem(_ item: Item, handler: ((UIAlertAction) -> Void)?) {
        let action = UIAlertAction(
            title: item.title,
            style: .default,
            handler: handler
        )
        action.setValue(item.image, forKey: "image")
        
        addAction(action)
    }
}
