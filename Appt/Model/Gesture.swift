//
//  Gesture.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

enum Gesture: String, CaseIterable {

    // Navigation
    case oneFingerTouch         = "one_finger_touch"
    case oneFingerSwipeRight    = "one_finger_swipe_right"
    case oneFingerSwipeLeft     = "one_finger_swipe_left"
    case fourFingerTapTop       = "four_finger_tap_top"
    case fourFingerTapBottom    = "four_finger_tap_bottom"
    case twoFingerSwipeDown     = "two_finger_swipe_down"
    case twoFingerSwipeUp       = "two_finger_swipe_up"
    case twoFingerTap           = "two_finger_tap"
    case threeFingerTap         = "three_finger_tap"
    
    // Scrolling
    case threeFingerSwipeUp     = "three_finger_swipe_up"
    case threeFingerSwipeRight  = "three_finger_swipe_right"
    case threeFingerSwipeDown   = "three_finger_swipe_down"
    case threeFingerSwipeLeft   = "three_finger_swipe_left"
    
    // Actions
    case oneFingerDoubleTap     = "one_finger_double_tap"
    case oneFingerTripleTap     = "one_finger_triple_tap"
    case twoFingerDoubleTap     = "two_finger_double_tap"
    case twoFingerZShape        = "two_finger_z_shape"
    case twoFingerDoubleTapHold = "two_finger_double_tap_hold"
    
    // Controls
    case threeFingerDoubleTap   = "three_finger_double_tap"
    case threeFingerTripleTap   = "three_finger_triple_tap"
    case twoFingerTripleTap     = "two_finger_triple_tap"
    case oneFingerDoubleTapHold = "one_finger_double_tap_hold"
    
    // Rotor
    case twoFingerRotate        = "two_finger_rotate"
    case oneFingerSwipeUp       = "one_finger_swipe_up"
    case oneFingerSwipeDown     = "one_finger_swipe_down"
    
    /** Identifier */
    var id: String {
        return rawValue
    }
    
    /** Title */
    var title: String {
        return NSLocalizedString("gesture_"+rawValue+"_title", comment: "")
    }
            
    /** Description */
    var description: String {
        return NSLocalizedString("gesture_"+rawValue+"_description", comment: "")
    }
    
    /** Explanation */
    var explanation: String {
        return NSLocalizedString("gesture_"+rawValue+"_explanation", comment: "")
    }
    
    /** Image */
    var image: UIImage? {
        return UIImage(named: "gesture_" + rawValue)
    }
    
    /** View */
    var view: GestureView {
        switch self {
        case .oneFingerTouch:
            return TouchGestureView(gesture: self, taps: 1, fingers: 1)
        case .oneFingerSwipeRight:
            return SwipeGestureView(gesture: self, direction: .right, fingers: 1)
        case .oneFingerSwipeLeft:
            return SwipeGestureView(gesture: self, direction: .left, fingers: 1)
        case .fourFingerTapTop:
            return TapGestureView(gesture: self, taps: 1, fingers: 4, position: .top)
        case .fourFingerTapBottom:
            return TapGestureView(gesture: self, taps: 1, fingers: 4, position: .bottom)
        case .twoFingerSwipeUp:
            return SwipeGestureView(gesture: self, direction: .up, fingers: 2)
        case .twoFingerSwipeDown:
            return SwipeGestureView(gesture: self, direction: .down, fingers: 2)
        case .twoFingerTap:
            return TapGestureView(gesture: self, taps: 1, fingers: 2)
        case .threeFingerTap:
            return TapGestureView(gesture: self, taps: 1, fingers: 3)
        
        case .threeFingerSwipeUp:
            return SwipeGestureView(gesture: self, direction: .up, fingers: 3)
        case .threeFingerSwipeRight:
            return SwipeGestureView(gesture: self, direction: .right, fingers: 3)
        case .threeFingerSwipeDown:
            return SwipeGestureView(gesture: self, direction: .down, fingers: 3)
        case .threeFingerSwipeLeft:
            return SwipeGestureView(gesture: self, direction: .left, fingers: 3)
            
        case .oneFingerDoubleTap:
            return TapGestureView(gesture: self, taps: 2, fingers: 1)
        case .oneFingerTripleTap:
            return TapGestureView(gesture: self, taps: 3, fingers: 1)
        case .twoFingerDoubleTap:
            return TapGestureView(gesture: self, taps: 2, fingers: 2)
        case .twoFingerZShape:
            return EscapeGestureView(gesture: self, fingers: 2)
        case .twoFingerDoubleTapHold:
            return LongPressGestureView(gesture: self, taps: 2, fingers: 2)
            
        case .threeFingerDoubleTap:
            return TapGestureView(gesture: self, taps: 2, fingers: 3)
        case .threeFingerTripleTap:
            return TapGestureView(gesture: self, taps: 3, fingers: 3)
        case .twoFingerTripleTap:
            return TapGestureView(gesture: self, taps: 3, fingers: 2)
        case .oneFingerDoubleTapHold:
            return DirectGestureView(gesture: self)
            
        case .twoFingerRotate:
            return RotationGestureView(gesture: self, fingers: 2, rotation: 0.5)
        case .oneFingerSwipeUp:
            return SwipeGestureView(gesture: self, direction: .up, fingers: 1)
        case .oneFingerSwipeDown:
            return SwipeGestureView(gesture: self, direction: .down, fingers: 1)
        }
    }
    
    /** Completion state */
    var completed: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: id)
        }
        get {
            return UserDefaults.standard.bool(forKey: id)
        }
    }
    
    static func shuffled() -> [Gesture] {
        var gestures = allCases
        gestures.shuffle()
        return gestures
    }
}
