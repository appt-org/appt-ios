//
//  KnowledgeViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 22/02/2021.
//  Copyright © 2021 Stichting Appt All rights reserved.
//

import UIKit
import Accessibility

class KnowledgeViewController: TableViewController {
    
    private let KENNISBANK_ID = 676
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if articles.isEmpty {
            getArticles()
        }
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        getArticles()
    }
    
    func getArticles() {
        if isLoading {
            return
        }
        
        if !refreshControl.isRefreshing {
            isLoading = true
        }
        
        API.shared.getArticles(type: .page, parentId: KENNISBANK_ID) { (response) in
            self.refreshControl.endRefreshing()
            self.isLoading = false
            
            if let articles = response.result {
                self.articles = articles
                self.tableView.reloadData()
            } else if let error = response.error {
                self.showError(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController, let article = sender as? Article {
            articleViewController.type = article.type
            articleViewController.id = article.id
        }
    }
}

// MARK: - UITableView

extension KnowledgeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let article = articles[indexPath.row]
        cell.setup(article.title.decoded)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let article = articles[indexPath.row]
        
        let articleViewController = UIStoryboard.article(type: article.type, id: article.id)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}

//
////
////  HomeViewController.swift
////  Appt
////
////  Created by Yurii Kozlov on 5/13/21.
////  Copyright © 2021 Stichting Appt. All rights reserved.
////
//
//import UIKit
//
//final class HomeViewController: ViewController {
//    @IBOutlet private var userProfSegmentedControl: UISegmentedControl!
//    @IBOutlet private var container: UIView!
//
//    //MARK: - Replace with API Download
//    var subject = Subject.loadJson()
//
//    let tableViewCellSpacing: CGFloat = 8
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "home_vc_title".localized
//
//        userProfSegmentedControl.isHidden = navigationController?.viewControllers.count ?? 0 > 1
//        
//        ViewEmbedder.embed(
//            withIdentifier: self.subject.subjectType == .blocks ? "SubjectBlocksViewController" : "SubjectListViewController", // Storyboard ID
//            parent: self,
//            container: self.container) { vc in
//
//            switch self.subject.subjectType {
//            case .blocks:
//                (self.children.first as? SubjectBlocksViewController)?.collectionView.delegate = self
//                (self.children.first as? SubjectBlocksViewController)?.collectionView.dataSource = self
//            case .list:
//                (self.children.first as? SubjectListViewController)?.tableView.delegate = self
//                (self.children.first as? SubjectListViewController)?.tableView.dataSource = self
//            }
//        }
//    }
//    
//    @IBAction private func userProfessionalSegmentedControlValueChanged(_ sender: UISegmentedControl) {
//        guard let _ = UserType(rawValue: sender.selectedSegmentIndex) else {
//            fatalError("Unable to determine UserType")
//        }
//
//        //MARK: - reload data source here
//    }
//}
//
//extension HomeViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            let view = tableView.cell(ListTableTopSectionHeaderView.self)
//
//            view.setup(subject)
//            
//            return view.systemLayoutSizeFitting(CGSize(width: tableView.frame.width, height: UIView.layoutFittingExpandedSize.height),
//                                                      withHorizontalFittingPriority: .required,
//                                                      verticalFittingPriority: .fittingSizeLevel).height
//        } else {
//            return tableViewCellSpacing
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            let view = tableView.cell(ListTableTopSectionHeaderView.self)
//            
//            view.setup(subject)
//            
//            return view
//        } else {
//            let headerView = UIView()
//            headerView.backgroundColor = .clear
//            return headerView
//        }
//    }
//}
//
//extension HomeViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleTableViewCell.identifier, for: indexPath) as? ImageTitleTableViewCell else {
//            fatalError("unable to dequeue ImageTitleTableViewCell")
//        }
//
//        let model = subject.children[indexPath.section]
//        cell.setup(model)
//        return cell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        subject.children.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//}
//
//extension HomeViewController: UICollectionViewDelegate {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        subject.children.count
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let model = subject.children[indexPath.section]
//
//        if model.children.isEmpty, let url = model.webURL {
//            let articleViewController = UIStoryboard.article(type: .page, url: url)
//            navigationController?.pushViewController(articleViewController, animated: true)
//
//        } else {
//            let viewController = UIStoryboard.home(subject: model)
//            navigationController?.pushViewController(viewController, animated: true)
//        }
//    }
//}
//
//extension HomeViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
//            fatalError("unable to dequeue CategoryCollectionViewCell")
//        }
//
//        let model = subject.children[indexPath.row]
//        cell.setup(model)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = subject.children[indexPath.row]
//
//        if model.children.isEmpty, let url = model.webURL {
//            let articleViewController = UIStoryboard.article(type: .page, url: url)
//            navigationController?.pushViewController(articleViewController, animated: true)
//
//        } else {
//            let viewController = UIStoryboard.home(subject: model)
//            navigationController?.pushViewController(viewController, animated: true)
//        }
//    }
//}
//
//extension HomeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let noOfCellsInRow = 2
//        
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//
//        let totalSpace = flowLayout.sectionInset.left
//            + flowLayout.sectionInset.right
//            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
//
//        return CGSize(width: size, height: size)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//
//        switch kind {
//
//        case UICollectionView.elementKindSectionHeader:
//            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BlocksCollectionSectionHeaderView", for: indexPath) as? BlocksCollectionSectionHeaderView else {
//                fatalError()
//            }
//
//            headerView.setup(subject)
//
//            return headerView
//
//        default:
//            assert(false, "Unexpected element kind")
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))
//
//        // Use this view to calculate the optimal size based on the collection view's width
//        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
//                                                  withHorizontalFittingPriority: .required, // Width is fixed
//                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
//    }
//}
