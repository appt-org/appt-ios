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
    case confirmEmail = "user_email_confirmation"
}

final class DeepLinkManager {
    func handleDeepLink(url: URL?) {
        guard let deepLink = url else { return }
        var queries = deepLink.queryParameters
        if let actionString = queries?["action"], let action = DeepLinkAction(rawValue: actionString) {
            switch action {
            case .resetPassword:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DeepLinkAction.resetPassword.rawValue), object: nil, userInfo: queries)
            default: break
            }
        } else if deepLink.pathComponents.contains(DeepLinkAction.confirmEmail.rawValue) {
            queries?["url"] = deepLink.absoluteString
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: DeepLinkAction.confirmEmail.rawValue), object: nil, userInfo: queries)
        }
    }
}
