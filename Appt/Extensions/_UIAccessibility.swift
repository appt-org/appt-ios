//
//  _UIAccessibility.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 02/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

extension UIAccessibility {
    static func focus(_ argument: UIView, delay:Double = 0.0) {
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: argument)
            }
        } else {
            UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: argument)
        }
    }
    
    static func announce(_ argument: String, delay: Double = 0.0) {
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: argument)
            }
        } else {
            UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: argument)
        }
    }
    
    static func mute(delay: Double = 0.0) {
        UIAccessibility.announce("  ", delay: delay)
    }
    
    static func announcement(for notification: Foundation.Notification) -> String? {
        return notification.userInfo?[UIAccessibility.announcementStringValueUserInfoKey] as? String
    }
    
    static func success(for notification: Foundation.Notification) -> Bool? {
        return notification.userInfo?[UIAccessibility.announcementWasSuccessfulUserInfoKey] as? Bool
    }
}
