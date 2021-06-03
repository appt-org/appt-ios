//
//  SubjectsViewController.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 28.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit
import Accessibility

class SubjectsViewController: ViewController {
    enum ViewControllerType {
        case knowledgeBase
        case services
        
        var title: String {
            switch self {
            case .knowledgeBase:
                return "kennisbank_appt_home_title".localized
            case .services:
                return "services_vc_title".localized
            }
        }
    }
    
    @IBOutlet private var container: UIView!
    
    var viewControllerType: ViewControllerType = .knowledgeBase
    
    var subject: Subject?

    let tableViewCellSpacing: CGFloat = 8
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if subject == nil {
            loadSubject()
        } else {
            embedViewController()
        }
    }
    
    private func loadSubject() {
        let callback: (Subject?, String?) -> () = { subject, errorString in
            self.isLoading = false
            if let error = errorString {
                Alert.error(error, viewController: self)
            } else {
                self.subject = subject
                self.embedViewController()
            }
        }
        
        self.isLoading = true
        switch viewControllerType {
        case .knowledgeBase:
            API.shared.getKnowledgeBase(callback)
        case .services:
            API.shared.getServices(callback)
        }
    }
    
    private func embedViewController() {
        guard let subject = self.subject else { return }
        
        title = subject.title
        
        ViewEmbedder.embed(
            withIdentifier: subject.subjectType == .blocks ? "SubjectBlocksViewController" : "SubjectListViewController", // Storyboard ID
            parent: self,
            container: self.container) { vc in

            switch subject.subjectType {
            case .blocks:
                (self.children.first as? SubjectBlocksViewController)?.collectionView.delegate = self
                (self.children.first as? SubjectBlocksViewController)?.collectionView.dataSource = self
            case .list:
                (self.children.first as? SubjectListViewController)?.tableView.delegate = self
                (self.children.first as? SubjectListViewController)?.tableView.dataSource = self
            }
        }
    }
    
    private func pushNextSubject(_ subject: Subject) {
        var viewController: UIViewController?
        switch viewControllerType {
        case .knowledgeBase:
            viewController = UIStoryboard.knowledgeBase(subject: subject)
        case .services:
            viewController = UIStoryboard.services(subject: subject)
        }
            
        if let viewController = viewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SubjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            let view = tableView.cell(ListTableTopSectionHeaderView.self)

            guard let subject = self.subject else { return 0.0 }
            
            view.setup(subject)
            
            return view.systemLayoutSizeFitting(CGSize(width: tableView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel).height
        } else {
            return tableViewCellSpacing
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.cell(ListTableTopSectionHeaderView.self)
            
            guard let subject = self.subject else { return nil }
            
            view.setup(subject)
            
            return view
        } else {
            let headerView = UIView()
            headerView.backgroundColor = .clear
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let subject = self.subject else { return }
        
        let model = subject.children[indexPath.section]

        if model.children.isEmpty, let url = model.webURL {
            let articleViewController = UIStoryboard.article(type: .page, completeUrl: url)
            navigationController?.pushViewController(articleViewController, animated: true)

        } else {
            pushNextSubject(model)
        }
    }
}

extension SubjectsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleTableViewCell.identifier, for: indexPath) as? ImageTitleTableViewCell else {
            fatalError("unable to dequeue ImageTitleTableViewCell")
        }
        
        guard let subject = self.subject else { return UITableViewCell() }

        let model = subject.children[indexPath.section]
        cell.setup(model)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let subject = self.subject else { return 0 }
        
        return subject.children.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}

extension SubjectsViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let subject = self.subject else { return 0 }
        
        return subject.children.count
    }
}

extension SubjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            fatalError("unable to dequeue CategoryCollectionViewCell")
        }
        
        guard let subject = self.subject else { return UICollectionViewCell() }

        let model = subject.children[indexPath.item]
        cell.setup(model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let subject = self.subject else { return }
        
        let model = subject.children[indexPath.item]

        if model.children.isEmpty, let url = model.webURL {
            let articleViewController = UIStoryboard.article(type: .page, url: url)
            navigationController?.pushViewController(articleViewController, animated: true)
        } else {
            pushNextSubject(model)
        }
    }
}

extension SubjectsViewController: UICollectionViewDelegateFlowLayout {
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
            
            guard let subject = self.subject else { return UICollectionReusableView() }

            headerView.setup(subject)

            return headerView

        default:
            fatalError("Unexpected element kind")
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
