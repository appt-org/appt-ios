//
//  FilterViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 03/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class FilterViewController: TableViewController {
    
    var categories: [Category]?
    var tags: [Tag]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
        tableView.refreshControl = refreshControl
        
        // Get filters
        getFilters()
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        getFilters()
    }
    
    private func getFilters() {
        if let categories = categories, let tags = tags {
            onFilters(categories, tags)
            return
        }
        
        if !refreshControl.isRefreshing {
            isLoading = true
        }
        
        API.shared.getFilters { (categories, tags, error) in
            self.refreshControl.endRefreshing()
            self.isLoading = false
            
            if let categories = categories, let tags = tags {
                self.onFilters(categories, tags)
            } else if let error = error {
                self.onError(error)
            }
        }
    }
    
    private func onFilters(_ categories: [Category], _ tags: [Tag]) {
        self.categories = categories
        self.tags = tags
        tableView.reloadData()
    }
    
    private func onError(_ error: Error) {
        print("Error", error)
    }
    
    @IBAction func onSaveTapped(_ sender: Any) {
        performSegue(withIdentifier: "applyFilters", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let knowledgeViewController = segue.destination as? KnowledgeViewController {
            knowledgeViewController.categories = self.categories
            knowledgeViewController.tags = self.tags
            print("Passed filters")
        }
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = categories, let _ = tags {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Categorieën"
        } else {
            return "Tags"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categories?.count ?? 0
        } else {
            return tags?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        if indexPath.section == 0 {
            guard let category = categories?[indexPath.row] else {
                fatalError()
            }
            cell.taxonomy = category
        } else {
            guard let tag = tags?[indexPath.row] else {
                fatalError()
            }
            cell.taxonomy = tag
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, let category = categories?[indexPath.row] {
            category.selected = !category.selected
        } else if indexPath.section == 1, let tag = tags?[indexPath.row] {
            tag.selected = !tag.selected
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
