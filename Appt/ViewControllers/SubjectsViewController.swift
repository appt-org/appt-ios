//
//  SubjectsViewController.swift
//  Appt
//
//  Created by Yulian Baranetskyy on 28.05.2021.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit
import Accessibility

enum BlocksSections: Int, CaseIterable {
    case headerCell = 0
    case blocks

    var sectionInset: UIEdgeInsets {
        switch self {
        case .blocks:
            return UIEdgeInsets(top: 0, left: 23, bottom: 16, right: 23)
        case .headerCell:
            return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        }
    }
}

class SubjectsViewController: ViewController {
    enum ViewControllerType {
        case home
        case knowledgeBase
        case services
        case more
        
        var title: String {
            switch self {
            case .home:
                return "home_vc_title".localized
            case .knowledgeBase:
                return "kennisbank_appt_home_title".localized
            case .services:
                return "services_vc_title".localized
            case .more:
                return "more_vc_title".localized
            }
        }
    }

    @IBOutlet private var container: UIView!
    
    var viewControllerType: ViewControllerType = .knowledgeBase
    
    var subject: Subject?

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
        case .home:
            API.shared.getHome(callback)
        case .knowledgeBase:
            API.shared.getKnowledgeBase(callback)
        case .services:
            API.shared.getServices(callback)
        case .more:
            API.shared.getMore(callback)
        }
    }
    
    private func embedViewController() {
        guard let subject = subject else { return }
        
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
        case .home:
            viewController = UIStoryboard.home(subject: subject)
        case .knowledgeBase:
            viewController = UIStoryboard.knowledgeBase(subject: subject)
        case .services:
            viewController = UIStoryboard.services(subject: subject)
        case .more:
            viewController = UIStoryboard.more(subject: subject)
        }
            
        if let viewController = viewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SubjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            let view = tableView.headerFooter(HeaderTableViewCell.self)

            guard let subject = self.subject else { return 0.0 }

            view.setup(subject)

            return view.systemLayoutSizeFitting(CGSize(width: tableView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel).height
        } else {
            return .zero
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.headerFooter(HeaderTableViewCell.self)

            guard let subject = self.subject else { return nil }

            view.setup(subject)

            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let subject = self.subject else { return }
        
        let model = subject.children[indexPath.row]

        if model.children.isEmpty {
            openWebsite(model.url)
        } else {
            pushNextSubject(model)
        }
    }
}

extension SubjectsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTableViewCell.identifier, for: indexPath) as? SubjectTableViewCell else {
            fatalError("unable to dequeue SubjectTableViewCell")
        }
        
        guard let subject = self.subject else { return UITableViewCell() }

        let model = subject.children[indexPath.row]
        cell.setup(model)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let subject = self.subject else { return 0 }

        return subject.children.count
    }
}

extension SubjectsViewController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        BlocksSections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let blocksSection = BlocksSections(rawValue: section) else {
            fatalError("Could not figure out what the section is")
        }

        guard let subject = self.subject else { return 0 }

        switch blocksSection {
        case .blocks:
            return subject.children.count
        case .headerCell:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let blocksSection = BlocksSections(rawValue: indexPath.section) else {
            fatalError("Could not figure out what the section is")
        }

        guard let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let availableWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width

        let noOfCellsInRow: CGFloat = blocksSection == .blocks ? (UIApplication.shared.statusBarOrientation.isLandscape ? 3 : 2) : 1

        let totalSpace = blocksSection.sectionInset.left
            +  blocksSection.sectionInset.right
            + (collectionViewLayout.minimumInteritemSpacing * (noOfCellsInRow - 1))

        let size = Int((availableWidth - totalSpace) / noOfCellsInRow)

        return CGSize(
            width: size,
            height: 155
        )
    }
}

extension SubjectsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let blocksSection = BlocksSections(rawValue: indexPath.section) else {
            fatalError("Could not figure out what the section is")
        }

        switch blocksSection {
        case .blocks:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCollectionViewCell.identifier, for: indexPath) as? SubjectCollectionViewCell else {
                fatalError("unable to dequeue SubjectCollectionViewCell")
            }
            guard let subject = self.subject else { return UICollectionViewCell() }

            let model = subject.children[indexPath.item]
            cell.setup(model)
            return cell
        case .headerCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, for: indexPath) as? HeaderCollectionViewCell else {
                fatalError("unable to dequeue HeaderCollectionViewCell")
            }
            guard let subject = self.subject else { return UICollectionViewCell() }

            cell.setup(subject)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let blocksSection = BlocksSections(rawValue: indexPath.section), blocksSection == .blocks else {
            return
        }

        guard let subject = self.subject else { return }
        
        let model = subject.children[indexPath.item]

        if model.children.isEmpty, self.viewControllerType == .services {
            openWebsite(model.url)
        } else if !model.children.isEmpty {
            openWebsite(model.url)
        } else {
            pushNextSubject(model)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let blocksSection = BlocksSections(rawValue: section) else {
            fatalError("Could not figure out what the section is")
        }

        return blocksSection.sectionInset
    }
}
