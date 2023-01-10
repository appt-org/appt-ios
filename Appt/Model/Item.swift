//
//  Item.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 05/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit

enum Item {
    
    case back,
         bookmark,
         bookmarked,
         bookmarks,
         close,
         forward,
         home,
         history,
         jumpBack,
         jumpForward,
         more,
         reload,
         settings,
         share
    
    var image: UIImage? {
        switch self {
        case .back:
            return R.image.icon_back()
        case .close:
            return R.image.icon_close()
        case .bookmark:
            return R.image.icon_bookmark()
        case .bookmarks:
            return R.image.icon_bookmarks()
        case .bookmarked:
            return R.image.icon_bookmarked()
        case .forward:
            return R.image.icon_forward()
        case .jumpBack:
            return R.image.icon_jump_back()
        case .jumpForward:
            return R.image.icon_jump_forward()
        case .history:
            return R.image.icon_history()
        case .home:
            return R.image.icon_home()
        case .more:
            return R.image.icon_more()
        case .reload:
            return R.image.icon_reload()
        case .settings:
            return R.image.icon_settings()
        case .share:
            return R.image.icon_share()
        }
    }
    
    var title: String {
        switch self {
        case .back:
            return R.string.localizable.back()
        case .bookmark:
            return R.string.localizable.bookmark()
        case .bookmarked:
            return R.string.localizable.bookmarked()
        case .bookmarks:
            return R.string.localizable.bookmarks()
        case .close:
            return R.string.localizable.close()
        case .forward:
            return R.string.localizable.forward()
        case .history:
            return R.string.localizable.history()
        case .jumpBack:
            return R.string.localizable.jump_back()
        case .jumpForward:
            return R.string.localizable.jump_forward()
        case .home:
            return R.string.localizable.home()
        case .more:
            return R.string.localizable.more()
        case .reload:
            return R.string.localizable.reload()
        case .settings:
            return R.string.localizable.settings()
        case .share:
            return R.string.localizable.share()
        }
    }
    
    var secondary: Item? {
        switch self {
        case .back:
            return .jumpBack
        case .bookmark, .bookmarked:
            return .bookmarks
        case .forward:
            return .jumpForward
        default:
            return nil
        }
    }
}
