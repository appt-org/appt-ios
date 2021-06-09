//
//  InformationViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

class MoreViewController: TableViewController {
    @IBOutlet private var emailVerificationView: EmailVerificationView!

    let tableViewTopHeaderHeight: CGFloat = 8
    
    private var topics: KeyValuePairs<String, [Topic]> {
        return [
            "": [
                .myprofile
            ],
            "about_title".localized.uppercased(): [
                .source,
                .sidnfonds,
                .contact
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

        emailVerificationView.delegate = self

        guard let user = UserDefaultsStorage.shared.restoreUser() else { return }
        
        if user.isVerified {
            hideVerificationView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserDefaultsStorage.shared.restoreUser()?.isVerified == true {
            self.hideVerificationView()
        }
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

        headerView.textLabel?.font = .sourceSansPro(weight: .regular, size: 15, style: .headline)
        headerView.textLabel?.text = self.tableView(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? tableViewTopHeaderHeight : UITableView.automaticDimension - 16
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
            let viewController = UIStoryboard.profile()
            navigationController?.pushViewController(viewController, animated: true)
        } else if indexPath.section == 1 {
            if indexPath.row == 2 {
                guard let url = topic.slugURL else { return }
                
                let articleViewController = UIStoryboard.article(type: .page, completeUrl: url)
                navigationController?.pushViewController(articleViewController, animated: true)
            } else {
                openWebsite(topic.slug)
            }
        } else if indexPath.section == 2 {
            let articleViewController = UIStoryboard.article(type: .page, slug: topic.slug)
            navigationController?.pushViewController(articleViewController, animated: true)
        }
    }

    private func hideVerificationView() {
        NSLayoutConstraint(item: emailVerificationView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0).isActive = true
    }
}

extension MoreViewController: EmailVerificationViewDelegate {
    func okViewAction() {
        hideVerificationView()
    }
}
