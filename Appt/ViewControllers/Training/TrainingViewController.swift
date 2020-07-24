//
//  TrainingViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TrainingViewController: ViewController {

    @IBOutlet private var tableView: UITableView!
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension TrainingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subjects[section].key
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let subject = subjects[indexPath.section].value[indexPath.row]
        cell.setup(subject.rawValue)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TrainingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let subject = subjects[indexPath.section].value[indexPath.row]
        if subject == .voiceOverGestures {
            performSegue(.voiceOverGestures, sender: nil)
        }
    }
}
