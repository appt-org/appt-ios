//
//  VoiceOverActionsViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 18/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverActionsViewController: TableViewController {
 
    private var actions: KeyValuePairs<String, [Action]> {
        return [
            "actions_navigate".localized: [
                .headings,
                .links
            ],
            "actions_edit".localized: [
                .selection,
                .copy,
                .paste
            ]
        ]
    }
    
    private var lastSelectedRow: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = lastSelectedRow {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VoiceOverActionViewController {
            if let action = sender as? Action {
                vc.action = action
            }
        }
    }
}

// MARK: - UITableView

extension VoiceOverActionsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return actions[section].key
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        cell.action = actions[indexPath.section].value[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension VoiceOverActionsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedRow = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        
        let action = actions[indexPath.section].value[indexPath.row]
        performSegue(.voiceOverAction, sender: action)
    }
}
