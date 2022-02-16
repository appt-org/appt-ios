//
//  HomeViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/13/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class HomeViewController: SubjectsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllerType = .home
        title = viewControllerType.title
    }
}
