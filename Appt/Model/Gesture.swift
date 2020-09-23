//
//  Gesture.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

enum Gesture: String {

    // Navigation
    case touch
    case swipeRight
    case swipeLeft
    case fourFingerTapTop
    case fourFingerTapBottom
    case twoFingerSwipeDown
    case twoFingerSwipeUp
    case twoFingerTap
    case threeFingerTap
    
    // Scrolling
    case scrollUp
    case scrollRight
    case scrollDown
    case scrollLeft
    
    // Actions
    case doubleTap
    case tripleTap
    case slide
    case magicTap
    case escape
    case label
    
    // Controls
    case threeFingerDoubleTap
    case threeFingerTripleTap
    case doubleTapLongPress
    case twoFingerTripleTap
    
    // Rotor
    case rotor
    case swipeUp
    case swipeDown
    
    /** Title of the gesture */
    var title: String {
        return NSLocalizedString("gesture_"+rawValue+"_title", comment: "")
    }
            
    /** Description of the gesture */
    var description: String {
        return NSLocalizedString("gesture_"+rawValue+"_description", comment: "")
    }
    
    /** Explanation of the gesture */
    var explanation: String {
        return NSLocalizedString("gesture_"+rawValue+"_explanation", comment: "")
    }
    
    /** View to execute the gesture */
    var view: GestureView {
        switch self {
        case .touch:
            return TouchGestureView(gesture: self)
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
        case .slide:
            return SlideGestureView(gesture: self)
        case .magicTap:
            return TapGestureView(gesture: self, taps: 2, fingers: 2)
        case .escape:
            return EscapeGestureView(gesture: self)
        case .label:
            return LongPressGestureView(gesture: self, taps: 2, fingers: 2)
            
        case .threeFingerDoubleTap:
            return TapGestureView(gesture: self, taps: 2, fingers: 3)
        case .threeFingerTripleTap:
            return TapGestureView(gesture: self, taps: 3, fingers: 3)
        case .doubleTapLongPress:
            return DefaultGestureView(gesture: self)
        case .twoFingerTripleTap:
            return TapGestureView(gesture: self, taps: 3, fingers: 2)
            
        case .rotor:
            return RotationGestureView(gesture: self, rotation: 0.5)
        case .swipeUp:
            return SwipeGestureView(gesture: self, direction: .up, fingers: 1)
        case .swipeDown:
            return SwipeGestureView(gesture: self, direction: .down, fingers: 1)
        }
    }
    
    /** Completion state of the gesture */
    var completed: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: rawValue)
        }
    }
}
