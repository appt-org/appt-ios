//
//  UserTypeViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/27/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

struct UserRegistrationData {
    let userType: String
    let professtion: String
}

final class UserTypeViewController: TableViewController {
    @IBOutlet private var screenHeaderLabel: UILabel!
    @IBOutlet private var nextButton: PrimaryMultilineButton!

    private var userType: String?
    private var profession: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "account_creation_vc_title".localized
        self.screenHeaderLabel.text = "account_creation_role_text".localized

        self.nextButton.setTitle("next".localized, for: .normal)
        self.screenHeaderLabel.font = .sourceSansPro(weight: .bold, size: 17, style: .headline)

        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 25
        self.tableView.registerNib(TitleTableViewCell.self)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: UITableViewHeaderFooterView.identifier)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registrationVC = segue.destination as? RegistrationViewController,
           let userType = self.userType,
           let profession = self.profession {
            let registrationData = UserRegistrationData(userType: userType, professtion: profession)
            registrationVC.userRegistrationData = registrationData
        }
    }

    @IBAction private func nextButtonPressed(_ sender: PrimaryMultilineButton) {
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        UserTypeSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userTypeSection = UserTypeSection(rawValue: section) else {
            fatalError("Unable to get datasource for tableView")
        }

        return userTypeSection.dataSource.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let userTypeSection = UserTypeSection(rawValue: section) else {
            fatalError("Unable to get datasource for tableView")
        }

        return userTypeSection.sectionTitle.uppercased()
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

        guard let section = UserTypeSection(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserTypeSection.self)")
        }

        let rowValue = section.dataSource[indexPath.row]

        cell.setup(rowValue)
        cell.selectionStyle = .none

        switch section {
        case .userType:
            if self.userType == nil, indexPath.row == 0 {
                self.userType = rowValue
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                cell.accessoryType = .checkmark
                return cell
            } else {
                cell.accessoryType = self.userType == rowValue ? .checkmark : .none
            }
        case .profession:
            if self.profession == nil, indexPath.row == 0 {
                self.profession = rowValue
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                cell.accessoryType = .checkmark
                return cell
            } else {
                cell.accessoryType = self.profession == rowValue ? .checkmark : .none
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let section = UserTypeSection(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserTypeSection.self)")
        }

        let rowValue = section.dataSource[indexPath.row]

        switch section {
        case .userType:
            let selectedIndexPath = self.tableView.indexPathsForSelectedRows?.first(where: { $0.section == UserTypeSection.userType.rawValue })
            if let userType = self.userType, userType != rowValue, let selectedIndexPath = selectedIndexPath {
                let cell = tableView.cellForRow(at: selectedIndexPath)
                tableView.deselectRow(at: selectedIndexPath, animated: true)
                cell?.accessoryType = .none
            }
        case .profession:
            let selectedIndexPath = self.tableView.indexPathsForSelectedRows?.first(where: { $0.section == UserTypeSection.profession.rawValue })
            if let profession = self.profession, profession != rowValue, let selectedIndexPath = selectedIndexPath {
                let cell = tableView.cellForRow(at: selectedIndexPath)
                tableView.deselectRow(at: selectedIndexPath, animated: true)
                cell?.accessoryType = .none
            }

        }

        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let section = UserTypeSection(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserTypeSection.self)")
        }

        let rowValue = section.dataSource[indexPath.row]

        switch section {
        case .userType:
            return self.userType != rowValue ? indexPath : nil
        case .profession:
            return self.profession != rowValue ? indexPath : nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = UserTypeSection(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserTypeSection.self)")
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        let rowValue = section.dataSource[indexPath.row]

        switch section {
        case .profession:
            self.profession = rowValue
        case .userType:
            self.userType = rowValue
        }
    }
}
