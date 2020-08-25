//
//  _UIAccessibility.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 02/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

/// This class contains accessibility helper methods for Notification.
open class AccessibilityNotification {

    private var notification: Notification
    
    init(_ notification: Notification) {
        self.notification = notification
    }
    
    /// Announcement
    open var announcement: String? {
        get {
            return notification.userInfo?[UIAccessibility.announcementStringValueUserInfoKey] as? String
        }
    }
    
    /// Successful state
    open var successful: Bool? {
        get {
            return notification.userInfo?[UIAccessibility.announcementWasSuccessfulUserInfoKey] as? Bool
        }
    }
}


public extension Notification {
    
    /// Adds the `accessibility` field to all classes which inherit from Notification.
    var accessibility: AccessibilityNotification {
        get {
            return AccessibilityNotification(self)
        }
    }
}
