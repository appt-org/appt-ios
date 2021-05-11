//
//  UserTypeViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/27/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

fileprivate enum UserTypeSections: Int, CaseIterable {
    case userType
    case profession
}

final class UserTypeViewController: TableViewController {
    @IBOutlet private var screenHeaderLabel: UILabel!
    @IBOutlet private var nextButton: PrimaryMultilineButton!

    private var firstSectionSelectionIndexPath: IndexPath?
    private var secondSectionSelectionIndexPath: IndexPath?

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

    @IBAction private func nextButtonPressed(_ sender: PrimaryMultilineButton) {
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        UserTypeSections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SECTION: \(section)"
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

        guard let section = UserTypeSections(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserTypeSections.self)")
        }

        cell.setup("Cell: \(indexPath.row)")
        cell.selectionStyle = .none

        switch section {
        case .userType:
            if self.firstSectionSelectionIndexPath == nil, indexPath.row == 0 {
                self.firstSectionSelectionIndexPath = indexPath
                cell.isSelected = true
                cell.accessoryType = .checkmark
                return cell
            } else {
                cell.accessoryType = self.firstSectionSelectionIndexPath == indexPath ? .checkmark : .none
            }
        case .profession:
            if self.secondSectionSelectionIndexPath == nil, indexPath.row == 0 {
                self.secondSectionSelectionIndexPath = indexPath
                cell.isSelected = true
                cell.accessoryType = .checkmark
                return cell
            } else {
                cell.accessoryType = self.secondSectionSelectionIndexPath == indexPath ? .checkmark : .none
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let section = UserTypeSections(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserTypeSections.self)")
        }

        switch section {
        case .profession:
            if let selectedSecondSelectedCell = self.secondSectionSelectionIndexPath, selectedSecondSelectedCell != indexPath {
                let cell = tableView.cellForRow(at: selectedSecondSelectedCell)
                tableView.deselectRow(at: selectedSecondSelectedCell, animated: true)
                cell?.accessoryType = .none
            }
        case .userType:
            if let selectedFirstSelectedCell = self.firstSectionSelectionIndexPath, selectedFirstSelectedCell != indexPath {
                let cell = tableView.cellForRow(at: selectedFirstSelectedCell)
                tableView.deselectRow(at: selectedFirstSelectedCell, animated: true)
                cell?.accessoryType = .none
            }

        }

        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let section = UserTypeSections(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserTypeSections.self)")
        }

        switch section {
        case .userType:
            return self.firstSectionSelectionIndexPath != indexPath ? indexPath : nil
        case .profession:
            return self.secondSectionSelectionIndexPath != indexPath ? indexPath : nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = UserTypeSections(rawValue: indexPath.section) else {
            fatalError("Unable to get current section type - \(UserTypeSections.self)")
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        switch section {
        case .profession:
            self.secondSectionSelectionIndexPath = indexPath
        case .userType:
            self.firstSectionSelectionIndexPath = indexPath
        }
    }
}
