//
//  HomeViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/13/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController {
    @IBOutlet private var userProfSegmentedControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!

    private var dataSource: [HomeItem] {
        guard let userType = UserType(rawValue: userProfSegmentedControl.selectedSegmentIndex) else {
            fatalError("Unable to determine UserType")
        }
        
        switch userType {
        case .user:
            return [
                .training,
                .meldpunt,
                .community,
                .overAppt
            ]
        case .professional:
            return [
                .knowledgeBase,
                .aanpak,
                .training,
                .services,
                .overAppt
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "home_vc_title".localized

        userProfSegmentedControl.isHidden = navigationController?.viewControllers.count ?? 0 > 1
        
        collectionView.registerNib(CategoryCollectionViewCell.self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction private func userProfessionalSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let _ = UserType(rawValue: sender.selectedSegmentIndex) else {
            fatalError("Unable to determine UserType")
        }

        self.collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            fatalError("unable to dequeue CategoryCollectionViewCell")
        }

        let item = dataSource[indexPath.item]
        cell.setup(withTitle: item.title, image: item.image)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.item]

        switch item {
        
        case .training:
            let viewController = UIStoryboard.training()
            navigationController?.pushViewController(viewController, animated: true)
        case .meldpunt:
            openWebsite(item.slug)
        case .community:
            openWebsite(item.slug)
        case .overAppt:
            openWebsite(item.slug)
        case .knowledgeBase:
            self.tabBarController?.selectedIndex = 1
        case .aanpak:
            openWebsite(item.slug)
        case .services:
            self.tabBarController?.selectedIndex = 3
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BlocksCollectionSectionHeaderView", for: indexPath) as? BlocksCollectionSectionHeaderView else {
                fatalError()
            }

            guard let userType = UserType(rawValue: userProfSegmentedControl.selectedSegmentIndex) else {
                fatalError("Unable to determine UserType")
            }
            
            var title = ""
            switch userType {
            case .user:
                title = "user_header_title".localized
            case .professional:
                title = "professional_header_title".localized
            }
            
            headerView.setup(withTitle: title, image: .homeApptLogo)

            return headerView

        default:
            assert(false, "Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))

        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
}
