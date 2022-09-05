//
//  Item.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 05/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit

enum Item {
    
    case back, forward, share, bookmark, bookmarked, menu
    
    var image: UIImage? {
        switch self {
        case .back:
            return R.image.icon_back()
        case .forward:
            return R.image.icon_forward()
        case .share:
            return R.image.icon_share()
        case .bookmark:
            return R.image.icon_bookmark()
        case .bookmarked:
            return R.image.icon_bookmarked()
        case .menu:
            return R.image.icon_menu()
        }
    }
    
    var title: String {
        switch self {
        case .back:
            return R.string.localizable.back()
        case .forward:
            return R.string.localizable.forward()
        case .share:
            return R.string.localizable.share()
        case .bookmark:
            return R.string.localizable.bookmark()
        case .bookmarked:
            return R.string.localizable.bookmarked()
        case .menu:
            return R.string.localizable.menu()
        }
    }
    
    var secondary: String? {
        switch self {
        case .back:
            return R.string.localizable.back()
        case .forward:
            return R.string.localizable.forward()
        case .share:
            return nil
        case .bookmark:
            return nil
        case .bookmarked:
            return nil
        case .menu:
            return nil
        }
    }
}
