//
//  SubjectBlocksViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/13/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class SubjectBlocksViewController: ViewController {
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.registerNib(CategoryCollectionViewCell.self)
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        // Should be overridden to handle refresh logic
    }

    func loadMore() {
        // Can be overridden to implement 'infinite scrolling'
    }
}
