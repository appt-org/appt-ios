//
//  UserTypeViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/27/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

struct UserRegistrationData {
    var userTypes: Set<String>
    var professions: Set<String>
    
    var allRoles: Set<String> {
        var allRoles = userTypes
        professions.forEach {
            allRoles.insert($0)
        }
        
        return allRoles
    }
}

final class UserTypeViewController: TableViewController {
    @IBOutlet private var screenHeaderLabel: UILabel!
    @IBOutlet private var nextButton: PrimaryMultilineButton!

    private var userRegistrationData = UserRegistrationData(userTypes: [], professions: [])

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
            registrationVC.userRegistrationData = userRegistrationData
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        UserType.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userTypeSection = UserType(rawValue: section) else {
            fatalError("Unable to get datasource for tableView")
        }

        return userTypeSection.dataSource.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let userTypeSection = UserType(rawValue: section) else {
            fatalError("Unable to get datasource for tableView")
        }

        return userTypeSection.title.uppercased()
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

        guard let section = UserType(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserType.self)")
        }

        let rowValue = section.dataSource[indexPath.row]
        let rowId = section.ids[indexPath.row]

        cell.setup(rowValue)
        cell.selectionStyle = .none

        switch section {
        case .user:
            if userRegistrationData.allRoles.count == 0, indexPath.row == 0 {
                userRegistrationData.userTypes.insert(rowId)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                cell.accessoryType = .checkmark
                return cell
            } else {
                cell.accessoryType = userRegistrationData.userTypes.contains(rowId) ? .checkmark : .none
            }
        case .professional:
            cell.accessoryType = userRegistrationData.professions.contains(rowId) ? .checkmark : .none
        }

        return cell
    }
 
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if userRegistrationData.allRoles.count > 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            return indexPath
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = UserType(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserType.self)")
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        let rowId = section.ids[indexPath.row]

        switch section {
        case .professional:
            userRegistrationData.professions.insert(rowId)
        case .user:
            userRegistrationData.userTypes.insert(rowId)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let section = UserType(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserType.self)")
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        
        let rowId = section.ids[indexPath.row]

        switch section {
        case .professional:
            userRegistrationData.professions.remove(rowId)
        case .user:
            userRegistrationData.userTypes.remove(rowId)
        }
    }
}
