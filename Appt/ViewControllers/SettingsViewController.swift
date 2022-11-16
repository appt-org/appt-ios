//
//  SettingsViewController.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 17/05/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import Foundation
import UIKit
import Rswift

protocol SettingsViewControllerDelegate {
    func onZoomLevelChanged(_ value: Double)
}

class SettingsViewController: TableViewController {
        
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.settings_title()
        
        tableView.registerNib(StepperTableViewCell.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(StepperTableViewCell.self, at: indexPath)
        
        cell.setup(title: R.string.localizable.settings_zoom(), value: 100, min: 50, max: 200, step: 25)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - StepperTableViewCellDelegate

extension SettingsViewController: StepperTableViewCellDelegate {
    
    func stepperValueChanged(_ value: Double) {
        print("Stepper value changed: \(value)")
        delegate?.onZoomLevelChanged(value)
    }
}
