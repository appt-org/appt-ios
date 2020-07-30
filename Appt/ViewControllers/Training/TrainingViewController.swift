//
//  TrainingViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TrainingViewController: TableViewController {

    private var subjects: KeyValuePairs<String, [Subject]> {
        return [
            "VoiceOver": [
                .voiceOverGestures,
                .voiceOverActions,
            ]
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
    }
}

// MARK: - UITableView

extension TrainingViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subjects[section].key
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let subject = subjects[indexPath.section].value[indexPath.row]
        cell.setup(subject.rawValue)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let subject = subjects[indexPath.section].value[indexPath.row]
        if subject == .voiceOverGestures {
            performSegue(.voiceOverGestures, sender: nil)
        }
    }
}
