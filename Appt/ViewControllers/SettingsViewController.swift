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
    func onZoomChanged(_ scale: Double)
}

class SettingsViewController: TableViewController {
        
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.settings()
        
        tableView.registerNib(StepperTableViewCell.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(StepperTableViewCell.self, at: indexPath)
        
        cell.setup(title: R.string.localizable.settings_zoom(), value: Preferences.shared.zoomScale, min: 0.5, max: 2.0, step: 0.25)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - StepperTableViewCellDelegate

extension SettingsViewController: StepperTableViewCellDelegate {
    
    func onStepperValueChanged(_ value: Double) {
        print("Stepper value changed: \(value)")
        delegate?.onZoomChanged(value)
    }
}
