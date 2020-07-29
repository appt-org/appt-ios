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
    case swipeRight
    case swipeLeft
    
    case singleTap
    case doubleTap
    
    case fourFingerTapTop
    case fourFingerTapBottom
    
    case twoFingerSwipeDown
    case twoFingerSwipeUp
    
    // Scrolling
    case scrollUp
    case scrollRight
    case scrollDown
    case scrollLeft
    
    // Rotor
    case swipeUp
    case swipeDown
    
    /** Describes the action */
    var action: String {
        switch self {
        case .swipeRight:
            return "Naar het volgende onderdeel navigeren"
        case .swipeLeft:
            return "Naar het vorige onderdeel navigeren"
    
        case .singleTap:
            return "Een onderdeel selecteren en uitspreken"
        case .doubleTap:
            return "Het geselecteerde onderdeel activeren"
            
        case .fourFingerTapTop:
            return "Naar het eerste onderdeel gaan"
        case .fourFingerTapBottom:
            return "Naar het laatste onderdeel gaan"
            
        case .twoFingerSwipeUp:
            return "Volledig scherm laten voorlezen"
        case .twoFingerSwipeDown:
            return "Scherm laten voorlezen vanaf geselecteerde onderdeel"
        
        case .scrollUp:
            return "Eén pagina omlaag scrollen"
        case .scrollRight:
            return "Eén pagina naar rechts scrollen"
        case .scrollDown:
            return "Eén pagina omhoog scrollen"
        case .scrollLeft:
            return "Eén pagina naar links scrollen"
            
        case .swipeUp:
            return "Naar het vorige rotor onderdeel gaan"
        case .swipeDown:
            return "Naar het volgende rotor onderdeel gaan"
        }
    }
            
    /** Description of the gesture */
    var description: String {
        switch self {
        case .swipeRight:
            return "Veeg met één vinger naar rechts, om naar het volgende onderdeel te navigeren."
        case .swipeLeft:
            return "Veeg met één vinger naar links, om naar het vorige onderdeel te navigeren."
        
        case .singleTap:
            return "Tik met één vinger op het scherm om een onderdeel te selecteren."
        case .doubleTap:
            return "Dubbeltik met één vinger op het scherm om het geselecteerde onderdeel te activeren."
            
        case .fourFingerTapTop:
            return "Tik met vier vingers bovenaan het scherm, om naar het eerste onderdeel te gaan."
        case .fourFingerTapBottom:
            return "Tik met vier vingers onderaan het scherm, om naar het laatste onderdeel te gaan."
            
        case .twoFingerSwipeUp:
            return "Veeg met twee vingers omhoog, om het volledig scherm voor te laten lezen."
        case .twoFingerSwipeDown:
            return "Veeg met twee vingers naar beneden, om het scherm vanaf het geselecteerde onderdeel voor te laten lezen."
        
        case .scrollUp:
            return "Veeg met drie vingers omhoog, om één pagina omlaag te scrollen."
        case .scrollRight:
            return "Veeg met drie vingers naar rechts, om één pagina naar rechts te scrollen."
        case .scrollDown:
            return "Veeg met drie vingers omlaag, om één pagina omhoog te scrollen."
        case .scrollLeft:
            return "Veeg met drie vingers naar links, om één pagina naar links te scrollen."
            
        case .swipeUp:
            return "Veeg met één vinger omhoog, om naar het vorige rotor onderdeel te gaan."
        case .swipeDown:
            return "Veeg met één vinger omlaag, om naar het volgende rotor onderdeel te gaan."
        }
    }
    
    /** View to test the gesture */
    var view: GestureView {
        switch self {
        case .swipeRight:
            return SwipeGestureView(gesture: self, direction: .right)
        case .swipeLeft:
            return SwipeGestureView(gesture: self, direction: .left)
        
        case .singleTap:
            return TapGestureView(gesture: self, numberOfTaps: 1)
        case .doubleTap:
            return TapGestureView(gesture: self, numberOfTaps: 2)
            
        case .fourFingerTapTop:
            return TapGestureView(gesture: self, numberOfTaps: 1, numberOfFingers: 4, position: .top)
        case .fourFingerTapBottom:
            return TapGestureView(gesture: self, numberOfTaps: 1, numberOfFingers: 4, position: .bottom)
            
        case .twoFingerSwipeUp:
            return SwipeGestureView(gesture: self, direction: .up, numberOfFingers: 2)
        case .twoFingerSwipeDown:
            return SwipeGestureView(gesture: self, direction: .down, numberOfFingers: 2)
        
        case .scrollUp:
            return SwipeGestureView(gesture: self, direction: .up, numberOfFingers: 3)
        case .scrollRight:
            return SwipeGestureView(gesture: self, direction: .right, numberOfFingers: 3)
        case .scrollDown:
            return SwipeGestureView(gesture: self, direction: .down, numberOfFingers: 3)
        case .scrollLeft:
            return SwipeGestureView(gesture: self, direction: .left, numberOfFingers: 3)
            
        case .swipeUp:
            return SwipeGestureView(gesture: self, direction: .up)
        case .swipeDown:
            return SwipeGestureView(gesture: self, direction: .down)
        }
    }
    
    /** Completion state */
    var completed: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: self.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: self.rawValue)
        }
    }
}
