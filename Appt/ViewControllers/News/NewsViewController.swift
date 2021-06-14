//
//  NewsViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import Accessibility

class NewsViewController: TableViewController {
    @IBOutlet private var filterItem: UIBarButtonItem!
    
    private var articles = [Article]()
    private var page = 1
    private var pages: Int?
    
    var categories: [Category]?
    var tags: [Tag]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterItem.title = "articles_filter".localized
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
        tableView.refreshControl = refreshControl

        let size = CGRect(x: 0, y: 0, width: 0, height: 0.1)
        self.tableView.tableHeaderView = UIView(frame: size)
        self.tableView.tableFooterView = UIView(frame: size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if articles.isEmpty {
            getArticles()
        }
    }
        
    private func reset() {
        page = 1
        pages = nil
        articles.removeAll()
        tableView.reloadData()
    }
    
    @IBAction private func doFilter(_ sender: Any) {
        performSegue(.filter, sender: self)
    }
    
    @IBAction private func applyFilters(_ segue: UIStoryboardSegue) {
        reset()
        getArticles()
    }
        
    override func refresh(_ refreshControl: UIRefreshControl) {
        reset()
        getArticles()
    }
    
    override func loadMore() {
        if let pages = pages, page <= pages {
            getArticles()
        }
    }
    
    private func getArticles() {
        if isLoading {
            return
        }
        
        if !refreshControl.isRefreshing {
            isLoading = true
        }
        
        API.shared.getArticles(type: .post, page: page, categories: categories, tags: tags) { (response) in
            self.refreshControl.endRefreshing()
            self.isLoading = false
                        
            if let articles = response.result {
                Accessibility.announce("articles_loaded".localized(articles.count))
                
                self.page += 1
                self.pages = response.pages
                
                if self.page > 1 {
                    self.articles.append(contentsOf: articles)
                } else {
                    self.articles = articles
                }
                
                self.tableView.reloadData()
            } else if let error = response.error {
                self.showError(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filtersViewController = segue.destination as? FiltersViewController {
            filtersViewController.categories = categories
            filtersViewController.tags = tags
        }
    }
}

// MARK: - UITableView

extension NewsViewController {

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
