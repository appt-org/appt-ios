//
//  DeepLink.swift
//  Appt
//
//  Created by Yurii Kozlov on 6/4/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import NotificationCenter

enum DeepLinkAction: String {
    case resetPassword = "rp"
}

final class DeepLinkManager {
    func handleDeepLink(url: URL?) {
        guard let deepLink = url else { return }
        let queries = deepLink.queryParameters
        guard let actionString = queries?["action"], let action = DeepLinkAction(rawValue: actionString) else { return }

        switch action {
        case .resetPassword:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: DeepLinkAction.resetPassword.rawValue), object: nil, userInfo: queries)
        }
    }
}
