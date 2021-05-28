//
//  ServicesViewController.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 24.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

final class ServicesViewController: SubjectsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllerType = .services
        title = viewControllerType.title
    }
}
