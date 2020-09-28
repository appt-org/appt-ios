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
    
    private var topics: [Topic] = [
        .terms,
        .privacy,
        .accessibility
    ]

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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topics.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        if indexPath.section == 0 {
            let topic = topics[indexPath.row]
            cell.setup(topic.title)
        } else {
            cell.setup("Ondersteund door het SIDN fonds")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let topic = topics[indexPath.row]
            let articleViewController = UIStoryboard.article(type: .page, slug: topic.slug)
            navigationController?.pushViewController(articleViewController, animated: true)
        } else {
            openWebsite("https://www.sidnfonds.nl")
        }
    }
}
