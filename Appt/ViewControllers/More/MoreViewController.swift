//
//  MoreViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

final class MoreViewController: SubjectsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllerType = .more
        title = viewControllerType.title
    }
}
