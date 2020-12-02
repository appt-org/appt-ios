//
//  TrainingViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

class TrainingViewController: TableViewController {

    private var courses: KeyValuePairs<String, [Course]> {
        return [
            "training_voiceover".localized: [
                .voiceOverGestures,
                .voiceOverEnable,
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
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return courses[section].key
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let course = courses[indexPath.section].value[indexPath.row]
        cell.setup(course.title)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let course = courses[indexPath.section].value[indexPath.row]
        performSegue(withIdentifier: course.rawValue, sender: self)
    }
}
