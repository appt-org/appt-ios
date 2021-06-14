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

        collectionView.registerNib(CategoryCollectionViewCell.self)
    }

    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        // Should be overridden to handle refresh logic
    }

    func loadMore() {
        // Can be overridden to implement 'infinite scrolling'
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        configureAlignedCollectionViewFlowLayout()
    }

    private func configureAlignedCollectionViewFlowLayout() {
        guard let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout else { return }

        alignedFlowLayout.verticalAlignment = .top

        let noOfCellsInRow: CGFloat = UIDevice.current.orientation.isLandscape ? 3 : 2

        let totalSpace = alignedFlowLayout.sectionInset.left
            + alignedFlowLayout.sectionInset.right
            + (alignedFlowLayout.minimumInteritemSpacing * (noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / noOfCellsInRow)

        alignedFlowLayout.estimatedItemSize = CGSize(
            width: size,
            height: 200
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}
