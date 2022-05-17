//
//  _UIStoryboard.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum Name: String{
        case main = "Main"
    }
    
    private static func viewController<T: UIViewController>(_ storyboard: UIStoryboard.Name, identifier : T.Type? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        if let identifier = identifier {
            return storyboard.instantiateViewController(withIdentifier: String(describing: identifier)) as! T
        } else {
            return storyboard.instantiateInitialViewController() as! T
        }
    }
            
    static func initial() -> UIViewController? {
        let storyboard = UIStoryboard(name: Name.main.rawValue, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        return vc
    }
}
