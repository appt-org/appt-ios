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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
}
