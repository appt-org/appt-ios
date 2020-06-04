//
//  FilterViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 03/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class FilterViewController: ViewController {
    
    @IBOutlet private var tableView: UITableView!
    
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
        
        getFilters()
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        getFilters()
    }
    
    private func getFilters() {
        isLoading = true
        
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
        print("Categories", categories)
        self.categories = categories
        self.tags = tags
        tableView.reloadData()
    }
    
    private func onError(_ error: Error) {
        print("Error", error)
    }
    
    @IBAction func onSaveTapped(_ sender: Any) {
        // TODO: Save
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Categorieën"
        } else {
            return "Tags"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categories?.count ?? 0
        } else {
            return tags?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, let category = categories?[indexPath.row] {
            category.selected = !category.selected
        } else if indexPath.section == 1, let tag = tags?[indexPath.row] {
            tag.selected = !tag.selected
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
