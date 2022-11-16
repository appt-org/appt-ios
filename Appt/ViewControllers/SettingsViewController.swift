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

class SettingsViewController: TableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.settings_title()
    }
}
