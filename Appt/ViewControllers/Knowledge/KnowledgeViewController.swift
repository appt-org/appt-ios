//
//  KnowledgeViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 22/02/2021.
//  Copyright © 2021 Stichting Appt All rights reserved.
//

import UIKit

final class KnowledgeViewController: SubjectsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllerType = .knowledgeBase
        title = viewControllerType.title
    }
}
