//
//  NavigationController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 22/02/2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *), let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
    }
}
