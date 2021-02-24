//
//  KnowledgeViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 22/02/2021.
//  Copyright © 2021 Stichting Appt All rights reserved.
//

import UIKit
import Accessibility

class KnowledgeViewController: TableViewController {
    
    private let parentId = 676 // Kennisbank page ID
    private var pages = [Page]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
        tableView.refreshControl = refreshControl
        
        getArticles()
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        getArticles()
    }
    
    func getArticles() {
        if isLoading {
            return
        }
        
        if !refreshControl.isRefreshing {
            isLoading = true
        }
        
        API.shared.getArticles(type: .page, parentId: parentId) { (response) in
            self.refreshControl.endRefreshing()
            self.isLoading = false
            
            if let pages = response.result {
                self.pages = pages
                self.tableView.reloadData()
            } else if let error = response.error {
                self.showError(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController, let page = sender as? Page {
            articleViewController.type = page.type
            articleViewController.id = page.id
        }
    }
}

// MARK: - UITableView

extension KnowledgeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let page = pages[indexPath.row]
        cell.setup(page.title.decoded)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let page = pages[indexPath.row]
        
        let articleViewController = UIStoryboard.article(type: page.type, id: page.id)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}

