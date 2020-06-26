//
//  KnowledgeViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class KnowledgeViewController: ViewController {

    @IBOutlet private var tableView: UITableView!
    
    private var posts = [Post]()
    var categories: [Category]?
    var tags: [Tag]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        
        getPosts()
    }
    
    @IBAction func doFilter(_ sender: Any) {
        performSegue(.filter, sender: self)
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        posts.removeAll()
        tableView.reloadData()
        
        getPosts()
    }
    
    private func getPosts() {
        if !refreshControl.isRefreshing {
            isLoading = true
        }
        
        API.shared.getPosts(categories: categories, tags: tags) { (posts, error) in
            if let posts = posts {
                self.onPosts(posts)
            } else if let error = error {
                self.onError(error)
            }
            self.refreshControl.endRefreshing()
            self.isLoading = false
        }
    }
    
    private func onPosts(_ posts: [Post]) {
        self.posts = posts
        self.tableView.reloadData()
    }
    
    private func onError(_ error: Error) {
        print("Error", error)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController, let post = sender as? Post {
            articleViewController.id = post.id
        } else if let filterViewController = segue.destination as? FilterViewController {
            filterViewController.categories = categories
            filterViewController.tags = tags
        }
    }
    
    @IBAction func applyFilters(_ segue: UIStoryboardSegue) {
        posts.removeAll()
        tableView.reloadData()
        
        getPosts()
    }
}

// MARK: - UITableViewDataSource

extension KnowledgeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let post = posts[indexPath.row]
        cell.setup(post.title.decoded)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension KnowledgeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        performSegue(.article, sender: post)
    }
}
