//
//  InformationViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class InformationViewController: TableViewController {
    
    @IBOutlet private var shareItem: UIBarButtonItem!
    
    private var topics: KeyValuePairs<String, [Topic]> {
        return [
            "topic_legal".localized: [
                .terms,
                .privacy,
                .accessibility
            ],
            "topic_other".localized: [
                .source,
                .sidnfonds
            ]
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareItem.title = "app_share".localized
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
    }
    
    @IBAction private func onShareTapped(_ sender: Any) {
        guard let url = URL(string: "https://appt.nl/app") else {
            return
        }
        let shareViewController = UIActivityViewController(activityItems: [url], applicationActivities: [])
        shareViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(shareViewController, animated: true)
    }
}

// MARK: - UITableView

extension InformationViewController {
    
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
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let topic = topics[indexPath.section].value[indexPath.row]
        cell.setup(topic.title)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let topic = topics[indexPath.section].value[indexPath.row]
        
        if indexPath.section == 0 {
            let articleViewController = UIStoryboard.article(type: .page, slug: topic.slug)
            navigationController?.pushViewController(articleViewController, animated: true)
        } else {
            openWebsite(topic.slug)
        }
    }
}
