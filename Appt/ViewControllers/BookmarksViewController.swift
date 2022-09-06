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

class BookmarksViewController: TableViewController {
    
    var stack: CoreDataStack!
    private var pages = [WebPage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.bookmarks()
        
        tableView.registerNib(SubtitleTableViewCell.self)
        
        do {
            let fetchRequest = BookmarkedPage.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
            self.pages = try stack.objectContext.fetch(fetchRequest).map({ item in
                return WebPage(item: item)
            })
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
        cell.setup(title: page.title, subtitle: page.url)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let page = pages[indexPath.row]
        dismiss(animated: true)
        
        // TODO: Pass back page
    }
}
