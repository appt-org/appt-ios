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
    
    private let KENNISBANK_ID = 676
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if articles.isEmpty {
            getArticles()
        }
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
        
        API.shared.getArticles(type: .page, parentId: KENNISBANK_ID) { (response) in
            self.refreshControl.endRefreshing()
            self.isLoading = false
            
            if let articles = response.result {
                self.articles = articles
                self.tableView.reloadData()
            } else if let error = response.error {
                self.showError(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController, let article = sender as? Article {
            articleViewController.type = article.type
            articleViewController.id = article.id
        }
    }
}

// MARK: - UITableView

extension KnowledgeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let article = articles[indexPath.row]
        cell.setup(article.title.decoded)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let article = articles[indexPath.row]
        
        let articleViewController = UIStoryboard.article(type: article.type, id: article.id)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}

