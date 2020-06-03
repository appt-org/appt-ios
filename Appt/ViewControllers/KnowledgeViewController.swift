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
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primary
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
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
    
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        getPosts()
    }
    
    private func getPosts() {
        isLoading = true
        API.shared.getPosts { (posts, error) in
            self.isLoading = false
            self.refreshControl.endRefreshing()
            
            print("Posts", posts)
            print("Error", error)
            
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            }
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
        let articleViewController = UIStoryboard.article(post)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}
