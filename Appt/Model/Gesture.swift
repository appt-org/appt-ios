//
//  Gesture.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

enum Gesture: String {

    // Navigation
    case touch = "touch"
    case swipeRight = "swipe_right"
    case swipeLeft = "swipe_left"
    case fourFingerTapTop = "four_finger_tap_top"
    case fourFingerTapBottom = "four_finger_tap_bottom"
    case twoFingerSwipeDown = "two_finger_swipe_down"
    case twoFingerSwipeUp = "two_finger_swipe_up"
    case twoFingerTap = "two_finger_tap"
    case threeFingerTap = "three_finger_tap"
    
    // Scrolling
    case scrollUp = "scroll_up"
    case scrollRight = "scroll_right"
    case scrollDown = "scroll_down"
    case scrollLeft = "scroll_left"
    
    // Actions
    case doubleTap = "double_tap"
    case tripleTap = "triple_tap"
    case magicTap = "magic_tap"
    case escape = "escape"
    case label = "label"
    
    // Controls
    case threeFingerDoubleTap = "three_finger_double_tap"
    case threeFingerTripleTap = "three_finger_triple_tap"
    case twoFingerTripleTap = "two_finger_triple_tap"
    case directInteraction = "direct_interaction"
    
    // Rotor
    case rotor = "rotor"
    case swipeUp = "swipe_up"
    case swipeDown = "swipe_down"
    
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
        case .touch:
            return TouchGestureView(gesture: self, taps: 1, fingers: 1)
        case .swipeRight:
            return SwipeGestureView(gesture: self, direction: .right, fingers: 1)
        case .swipeLeft:
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
        
        case .scrollUp:
            return SwipeGestureView(gesture: self, direction: .up, fingers: 3)
        case .scrollRight:
            return SwipeGestureView(gesture: self, direction: .right, fingers: 3)
        case .scrollDown:
            return SwipeGestureView(gesture: self, direction: .down, fingers: 3)
        case .scrollLeft:
            return SwipeGestureView(gesture: self, direction: .left, fingers: 3)
            
        case .doubleTap:
            return TapGestureView(gesture: self, taps: 2, fingers: 1)
        case .tripleTap:
            return TapGestureView(gesture: self, taps: 3, fingers: 1)
        case .magicTap:
            return TapGestureView(gesture: self, taps: 2, fingers: 2)
        case .escape:
            return EscapeGestureView(gesture: self, fingers: 2)
        case .label:
            return LongPressGestureView(gesture: self, taps: 2, fingers: 2)
            
        case .threeFingerDoubleTap:
            return TapGestureView(gesture: self, taps: 2, fingers: 3)
        case .threeFingerTripleTap:
            return TapGestureView(gesture: self, taps: 3, fingers: 3)
        case .twoFingerTripleTap:
            return TapGestureView(gesture: self, taps: 3, fingers: 2)
        case .directInteraction:
            return DirectGestureView(gesture: self)
            
        case .rotor:
            return RotationGestureView(gesture: self, fingers: 2, rotation: 0.5)
        case .swipeUp:
            return SwipeGestureView(gesture: self, direction: .up, fingers: 1)
        case .swipeDown:
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
}
