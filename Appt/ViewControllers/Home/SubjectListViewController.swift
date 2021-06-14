//
//  SubjectListViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/14/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class SubjectListViewController: TableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(ListTableTopSectionHeaderView.self)
        tableView.registerNib(ImageTitleTableViewCell.self)

        let size = CGRect(x: 0, y: 0, width: 0, height: 0.1)
        self.tableView.tableHeaderView = UIView(frame: size)
    }
}
