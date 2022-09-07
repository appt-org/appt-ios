//
//  BookmarksViewController.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 06/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import Foundation
import UIKit
import Rswift
import WebKit
import CoreData

protocol PagesViewControllerDelegate {
    func didSelectPage(_ page: Page)
}

class PagesViewController: TableViewController {
    
    var delegate: PagesViewControllerDelegate?
    
    var stack: CoreDataStack!
    var item: Item!
    var pages = [Page]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item.title
        
        tableView.registerNib(SubtitleTableViewCell.self)
        
        if pages.isEmpty {
            // TODO: Merge fetch logic
            if item == .history {
                fetchHistory()
            } else {
                fetchBookmarks()
            }
        }
    }
        
    private func fetchHistory() {
        do {
            let fetchRequest = VisitedPage.createFetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
            self.pages = try stack.objectContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Failed to fetch: \(error) --> \(error.userInfo)")
        }
    }
    
    private func fetchBookmarks() {
        do {
            let fetchRequest = BookmarkedPage.createFetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
            self.pages = try stack.objectContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Failed to fetch: \(error) --> \(error.userInfo)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(SubtitleTableViewCell.self, at: indexPath)
        
        let page = pages[indexPath.row]
        cell.setup(page)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let page = pages[indexPath.row]
        delegate?.didSelectPage(page)
        
        dismiss(animated: true)
    }
}
