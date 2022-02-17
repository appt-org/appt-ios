//
//  InformationViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

class MoreViewController: TableViewController {
    
    private var topics: KeyValuePairs<String, [Topic]> {
        return [
            "about_title".localized: [
                .source,
                .contact
            ],
            "partners_title".localized: [
                .appt,
                .abra,
                .sidnfonds
            ],
            "legal_title".localized: [
                .terms,
                .privacy,
                .accessibility,
            ]
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "more_vc_title".localized
        
        // Set-up UITableView
        tableView.registerNib(ImageTitleTableViewCell.self)
    }
}

// MARK: - UITableView

extension MoreViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return topics[section].key
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics[section].value.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(ImageTitleTableViewCell.self, at: indexPath)
        
        let topic = topics[indexPath.section].value[indexPath.row]
        cell.setup(withTitle: topic.title, image: topic.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let topic = topics[indexPath.section].value[indexPath.row]
        openWebsite(topic.slug)
    }
}
