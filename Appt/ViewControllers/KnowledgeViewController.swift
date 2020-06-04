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
        performSegue(withIdentifier: "filter", sender: self)
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        getPosts()
    }
    
    private func getPosts() {
        isLoading = true
        API.shared.getPosts { (posts, error) in
            self.refreshControl.endRefreshing()
            self.isLoading = false
            
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else if let error = error {
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController, let post = sender as? Post {
            articleViewController.id = post.id
        }
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
        cell.setup(post.title.rendered.htmlDecoded)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension KnowledgeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        performSegue(withIdentifier: "article", sender: post)
    }
}
