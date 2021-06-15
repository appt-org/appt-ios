//
//  HomeViewController.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/13/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit
import NotificationCenter

final class HomeViewController: ViewController {
    @IBOutlet private var userProfSegmentedControl: UISegmentedControl!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var emailVerificationView: EmailVerificationView!

    var emailConfirmationObserver: NSObjectProtocol?
    
    private var dataSource: [HomeItem] {
        guard let userType = Role.UserType(rawValue: userProfSegmentedControl.selectedSegmentIndex) else {
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
        
        emailVerificationView.delegate = self

        hideVerificationView()


//        guard let user = UserDefaultsStorage.shared.restoreUser() else { return }
//
//        userProfSegmentedControl.selectedSegmentIndex = user.isProfessional ? 1 : 0
//
        Role.UserType.allCases.forEach({
            self.userProfSegmentedControl.setTitle($0.segmentedControlTitle, forSegmentAt: $0.rawValue)
        })
//
//        if user.isVerified {
//            hideVerificationView()
//        } else {
//            self.emailConfirmationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: DeepLinkAction.confirmEmail.rawValue), object: nil, queue: nil, using: {
//                self.confirmEmail($0)
//            })
//        }
//
//        getUser()
//
//        if (tabBarController as? TabBarController)?.shouldShowEmailVerificationAlert == true {
//            showEmailVerificationAlert()
//        }
    }

//    private func showEmailVerificationAlert() {
//        Alert.Builder()
//            .title("confirmation_alert_title".localized)
//            .message("confirmation_alert_message".localized)
//            .action("ok".localized)
//            .present(in: self)
//    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if UserDefaultsStorage.shared.restoreUser()?.isVerified == true {
//            self.hideVerificationView()
//        }
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        configureAlignedCollectionViewFlowLayout()


        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func configureAlignedCollectionViewFlowLayout() {
        guard let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout else { return }

        alignedFlowLayout.verticalAlignment = .top
        alignedFlowLayout.horizontalAlignment = .left

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
        super.traitCollectionDidChange(previousTraitCollection)

        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction private func userProfessionalSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let _ = Role.UserType(rawValue: sender.selectedSegmentIndex) else {
            fatalError("Unable to determine UserType")
        }

        let range = Range(uncheckedBounds: (0, collectionView.numberOfSections))
        let indexSet = IndexSet(integersIn: range)
        collectionView.reloadSections(indexSet)
    }
    
//    private func getUser() {
//        API.shared.getUser { user, error in
//            if let user = user, user.isVerified {
//                self.emailConfirmationObserver = nil
//                self.hideVerificationView()
//            } else if user == nil, let error = error {
//                Alert.error(error, viewController: self)
//            }
//        }
//    }

//    private func confirmEmail(_ notification: Notification) {
//        guard let topViewController =  UIApplication.topViewController() else { return }
//        guard let user = UserDefaultsStorage.shared.restoreUser() else { return }
//        guard let emailConfirmData = notification.userInfo as? [String: String],
//              let userID = emailConfirmData["user_id"],
//              let key = emailConfirmData["activation_key"] else {
//            Alert.error("email_verification_failed".localized, viewController: topViewController)
//            return
//        }
//
//        guard "\(user.id)" == userID else {
//            Alert.error("email_verification_failed_wrong_user".localized, viewController: topViewController)
//            return
//        }
//
//        guard !user.isVerified else {
//            Alert.error("email_verification_failed_already_verified".localized, viewController: topViewController)
//            return
//        }
//
//        API.shared.confirmUserEmail(userID: userID, key: key) { user, error in
//            if user != nil, error == nil {
//                Alert.Builder()
//                    .title("email_verification_alert_title".localized)
//                    .message("email_verification_successful".localized)
//                    .action("ok".localized) {
//                        self.emailConfirmationObserver = nil
//                        self.hideVerificationView()
//                    }.present(in: self)
//            } else if let error = error, user == nil {
//                Alert.error(error, viewController: topViewController)
//            }
//        }
//    }
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let alignedFlowLayout = collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout else { return .zero }


        let noOfCellsInRow: CGFloat = UIDevice.current.orientation.isLandscape ? 3 : 2

        let totalSpace = alignedFlowLayout.sectionInset.left
            + alignedFlowLayout.sectionInset.right
            + (alignedFlowLayout.minimumInteritemSpacing * (noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / noOfCellsInRow)

       return CGSize(
            width: size,
            height: 200
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.item]

        switch item {
        
        case .training:
            let viewController = UIStoryboard.training()
            navigationController?.pushViewController(viewController, animated: true)
        case .overAppt, .aanpak:
            guard let slug = item.slugURL?.lastPathComponent else { return }
            let articleViewController = UIStoryboard.article(type: .page, slug: slug)
            navigationController?.pushViewController(articleViewController, animated: true)
        case .community, .meldpunt:
            guard let url = item.slugURL else { return }
            openWebsite(url)
        case .knowledgeBase:
            self.tabBarController?.selectedIndex = 1
        case .services:
            self.tabBarController?.selectedIndex = 3
        }
    }

    private func hideVerificationView() {
        emailVerificationView.isHidden = true
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BlocksCollectionSectionHeaderView", for: indexPath) as? BlocksCollectionSectionHeaderView else {
                fatalError()
            }

            guard let userType = Role.UserType(rawValue: userProfSegmentedControl.selectedSegmentIndex) else {
                fatalError("Unable to determine UserType")
            }

            var title = ""
            switch userType {
            case .user:
                title = "user_header_title".localized
            case .professional:
                title = "professional_header_title".localized
            }

            headerView.setup(withTitle: title, image: .apptLogo)

            return headerView

        default:
            fatalError("Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0))

        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

extension HomeViewController: EmailVerificationViewDelegate {
    func okViewAction() {
        hideVerificationView()
    }
}
