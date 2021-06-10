//
//  UserTypeViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/27/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class UserTypeViewController: TableViewController {
    @IBOutlet private var screenHeaderLabel: UILabel!
    @IBOutlet private var nextButton: PrimaryMultilineButton!
    
    enum Section: Int, CaseIterable {
        case user
        case professional
    }
    
    var userTypeDataSource: [Section: [Role]] {
        [.user:
            [Role(withId: "ervaringsdeskundige")!,
             Role(withId: "geinteresseerde")!,
             Role(withId: "ambassadeur")!],
         .professional:
            [Role(withId: "designer")!,
             Role(withId: "tester")!,
             Role(withId: "ontwikkelaar")!,
             Role(withId: "manager")!,
             Role(withId: "toegankelijkheidsexpert")!,
             Role(withId: "auditor")!]
        ]
    }
    
    var selectedRoles: Set<Role> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "account_creation_vc_title".localized
        screenHeaderLabel.text = "account_creation_role_text".localized

        nextButton.setTitle("next".localized, for: .normal)
        screenHeaderLabel.font = .sourceSansPro(weight: .bold, size: 17, style: .headline)

        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        tableView.registerNib(TitleTableViewCell.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: UITableViewHeaderFooterView.identifier)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registrationVC = segue.destination as? RegistrationViewController {
            registrationVC.userRoles = selectedRoles
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        userTypeDataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Unable to get current section")
        }
        return userTypeDataSource[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            fatalError("Unable to get current section")
        }
        
        switch section {
        case .user:
            return "account_creation_user_type_section0_title_text".localized.uppercased()
        case .professional:
            return "account_creation_user_type_section1_title_text".localized.uppercased()
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }

        headerView.textLabel?.font = .sourceSansPro(weight: .regular, size: 14, style: .body)
        headerView.textLabel?.text = self.tableView(tableView, titleForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            fatalError("Unable to dequeue required cell type - \(TitleTableViewCell.self)")
        }
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unable to get current section")
        }
        
        guard let sectionDataSource = userTypeDataSource[section] else {
            fatalError("Unable to get current section")
        }
        
        let role = sectionDataSource[indexPath.row]

        cell.setup(role.title)
        cell.selectionStyle = .none

        cell.accessoryType = selectedRoles.contains(role) ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unable to get current section")
        }
        
        guard let sectionDataSource = userTypeDataSource[section] else {
            fatalError("Unable to get current section")
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        let role = sectionDataSource[indexPath.row]
        selectedRoles.insert(role)

        self.nextButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unable to get current section")
        }
        
        guard let sectionDataSource = userTypeDataSource[section] else {
            fatalError("Unable to get current section")
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        
        let role = sectionDataSource[indexPath.row]
        selectedRoles.remove(role)
    }
}
