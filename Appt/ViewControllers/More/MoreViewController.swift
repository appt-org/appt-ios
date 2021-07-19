//
//  InformationViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

class MoreViewController: TableViewController {
    let tableViewTopHeaderHeight: CGFloat = 8
    
    private var topics: KeyValuePairs<String, [Topic]> {
        return [
//            "": [
//                .myprofile
//            ],
            "about_title".localized.uppercased(): [
                .source,
                .contact,
                .sidnfonds
            ],
            "legal_title".localized.uppercased(): [
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }

        headerView.textLabel?.font = .openSans(weight: .regular, size: 15, style: .headline)
        headerView.textLabel?.text = self.tableView(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        section == 0 ? tableViewTopHeaderHeight : UITableView.automaticDimension
        UITableView.automaticDimension
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
        
        if indexPath.section == 0 {
            openWebsite(topic.slug)
        } else if indexPath.section == 1 {
            let articleViewController = UIStoryboard.article(type: .page, slug: topic.slug)
            navigationController?.pushViewController(articleViewController, animated: true)
        }
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let topic = topics[indexPath.section].value[indexPath.row]
//
//        if indexPath.section == 0 {
//            let viewController = UIStoryboard.profile()
//            navigationController?.pushViewController(viewController, animated: true)
//        } else if indexPath.section == 1 {
//            openWebsite(topic.slug)
//        } else if indexPath.section == 2 {
//            let articleViewController = UIStoryboard.article(type: .page, slug: topic.slug)
//            navigationController?.pushViewController(articleViewController, animated: true)
//        }
//    }
}
