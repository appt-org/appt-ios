//
//  TabBar.swift
//  Appt
//
//  Created by Yurii Kozlov on 6/8/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let states: [UIControl.State] = [.disabled, .focused, .normal, .selected]
        states.forEach { (state) in
            tabBar.items?.forEach({
                $0.setTitleTextAttributes([.font: UIFont.sourceSansPro(weight: .semibold, size: 14, style: .title1)], for: state)
            })
        }
    }
}
