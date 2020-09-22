//
//  TableViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TableViewController: ViewController {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primary
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        
    }
}

// MARK: - UITableViewDelegate

extension TableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Override cellForRowAt")
    }
}


// MARK: - UITableViewDelegate

extension TableViewController: UITableViewDelegate {
        
     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
            header.textLabel?.font = .sourceSansPro(weight: .bold, size: 20, style: .headline)
            header.textLabel?.textColor = .foreground
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
