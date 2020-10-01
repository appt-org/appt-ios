//
//  KnowledgeViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import Accessibility

class KnowledgeViewController: TableViewController {

    @IBOutlet private var filterItem: UIBarButtonItem!
    
    private var posts = [Post]()
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
        
        // Get posts
        getPosts()
    }
        
    private func reset() {
        page = 1
        pages = nil
        posts.removeAll()
        tableView.reloadData()
    }
    
    @IBAction private func doFilter(_ sender: Any) {
        performSegue(.filter, sender: self)
    }
    
    @IBAction private func applyFilters(_ segue: UIStoryboardSegue) {
        reset()
        getPosts()
    }
        
    override func refresh(_ refreshControl: UIRefreshControl) {
        reset()
        getPosts()
    }
    
    override func loadMore() {
        if let pages = pages, page <= pages {
            getPosts()
        }
    }
    
    private func getPosts() {
        if isLoading {
            return
        }
        
        if !refreshControl.isRefreshing {
            isLoading = true
        }
        
        API.shared.getArticles(type: .post, page: page, categories: categories, tags: tags) { (response) in
            self.page += 1
            self.pages = response.pages
            
            if let posts = response.result {
                Accessibility.announce("articles_loaded".localized(posts.count))
                
                if self.page > 1 {
                    self.posts.append(contentsOf: posts)
                } else {
                    self.posts = posts
                }
                
                self.tableView.reloadData()
            } else if let error = response.error {
                self.showError(error)
            }
            self.refreshControl.endRefreshing()
            self.isLoading = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController, let post = sender as? Post {
            articleViewController.type = post.type
            articleViewController.id = post.id
        } else if let filtersViewController = segue.destination as? FiltersViewController {
            filtersViewController.categories = categories
            filtersViewController.tags = tags
        }
    }
}

// MARK: - UITableView

extension KnowledgeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let post = posts[indexPath.row]
        cell.setup(post.title.decoded)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        performSegue(.article, sender: post)
    }
}
