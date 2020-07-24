//
//  Gesture.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation

enum Gesture {
    case singleTap
    case doubleTap
    
    case fourFingerTapTop
    case fourFingerTapBottom
    
    case scrollUp
    case scrollRight
    case scrollDown
    case scrollLeft
    
    case swipeUp
    case swipeDown
    
    case swipeRight
    case swipeLeft
    
    private var info: (action: String, description: String) {
        switch self {
        case .singleTap:
            return ("Een onderdeel selecteren en uitspreken", "Tik met één vinger op het scherm om een onderdeel te selecteren")
            
        case .doubleTap:
            return ("Het geselecteerde onderdeel activeren", "Dubbeltik met één vinger op het scherm om het geselecteerde onderdeel te activeren")
        
            
        case .fourFingerTapTop:
            return ("Naar het eerste onderdeel gaan", "Tik met vier vingers bovenaan het scherm, om naar het eerste onderdeel te gaan")
            
        case .fourFingerTapBottom:
            return ("Naar het laatste onderdeel gaan", "Tik met vier vingers onderaan het scherm, om naar het laatste onderdeel te gaan")
        
            
        case .scrollUp:
            return ("Eén pagina omhoog scrollen", "Veeg met drie vingers omlaag, om één pagina omhoog te scrollen")
            
        case .scrollRight:
            return ("Eén pagina naar rechts scrollen", "Veeg met drie vingers naar rechts, om één pagina naar rechts te scrollen")
            
        case .scrollDown:
            return ("Eén pagina omlaag scrollen", "Veeg met drie vingers omhoog, om één pagina omlaag te scrollen")
            
        case .scrollLeft:
            return ("Eén pagina naar links scrollen", "Veeg met drie vingers naar links, om één pagina naar links te scrollen")
            
        
        case .swipeUp:
            return ("Naar het vorige rotor onderdeel gaan", "Veeg met één vinger omhoog, om naar het vorige rotor onderdeel te gaan.")
            
        case .swipeDown:
            return ("Naar het volgende rotor onderdeel gaan", "Veeg met één vinger omlaag, om naar het volgende rotor onderdeel te gaan.")
            
            
        case .swipeRight:
            return ("Naar het volgende onderdeel navigeren", "Veeg met één vinger naar rechts, om naar het volgende onderdeel te navigeren.")
            
        case .swipeLeft:
            return ("Naar het vorige onderdeel navigeren", "Veeg met één vinger naar links, om naar het vorige onderdeel te navigeren.")
        }
    }
    
    var action: String {
        return info.action
    }
    
    var description: String {
        return info.description
    }
    
    var view: GestureView {
        switch self {
        case .singleTap:
            return SingleTapGestureView()
        case .doubleTap:
            return DoubleTapGestureView()
            
        case .fourFingerTapTop:
            return FourTapTopGestureView()
        case .fourFingerTapBottom:
            return FourTapBottomGestureView()
            
        case .scrollUp:
            return ScrollUpGestureView()
        case .scrollRight:
            return ScrollRightGestureView()
            
        case .scrollDown:
            return ScrollDownGestureView()
        case .scrollLeft:
            return ScrollLeftGestureView()
            
        case .swipeUp:
            return SwipeUpGestureView()
        case .swipeDown:
            return SwipeDownGestureView()
            
        case .swipeLeft:
            return SwipeLeftGestureView()
        case .swipeRight:
            return SwipeRightGestureView()
        }
    }
}
