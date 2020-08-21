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
    
    /** Describes the action */
    var action: String {
        switch self {
        case .touch:
            return "Een onderdeel selecteren en uitspreken"
        case .swipeRight:
            return "Naar het volgende onderdeel navigeren"
        case .swipeLeft:
            return "Naar het vorige onderdeel navigeren"
        case .fourFingerTapTop:
            return "Naar het eerste onderdeel gaan"
        case .fourFingerTapBottom:
            return "Naar het laatste onderdeel gaan"
        case .twoFingerSwipeUp:
            return "Volledig scherm laten voorlezen"
        case .twoFingerSwipeDown:
            return "Scherm laten voorlezen vanaf geselecteerde onderdeel"
        case .twoFingerTap:
            return "Het voorlezen pauzeren of hervatten"
        case .threeFingerTap:
            return "Extra informatie laten uitspreken"
        
        case .scrollUp:
            return "Eén pagina omlaag scrollen"
        case .scrollRight:
            return "Eén pagina naar rechts scrollen"
        case .scrollDown:
            return "Eén pagina omhoog scrollen"
        case .scrollLeft:
            return "Eén pagina naar links scrollen"
            
        case .doubleTap:
            return "Het geselecteerde onderdeel activeren"
        case .tripleTap:
            return "Dubbeltikken op het geselecteerde onderdeel"
        case .slide:
            return "Een schuifknop slepen"
        case .magicTap:
            return "De actuele handeling starten of stoppen"
        case .escape:
            return "Een melding sluiten of teruggaan naar het vorige scherm"
        case .label:
            return "Het label van een onderdeel wijzigen"
            
        case .threeFingerDoubleTap:
            return "Het geluid van VoiceOver in- of uitschakelen"
        case .threeFingerTripleTap:
            return "Het schermgordijn in- of uitschakelen"
        case .doubleTapLongPress:
            return "Een standaardgebaar gebruiken"
        case .twoFingerTripleTap:
            return "De onderdeelkiezer openen"
            
        case .rotor:
            return "Een rotorinstelling kiezen"
        case .swipeUp:
            return "Rotoronderdeel omhoog aanpassen"
        case .swipeDown:
            return "Rotoronderdeel omlaag aanpassen"
        }
    }
            
    /** Description of the gesture */
    var description: String {
        switch self {
        case .touch:
            return "Raak het scherm aan om een onderdeel te selecteren en uit te spreken."
        case .swipeRight:
            return "Veeg met één vinger naar rechts, om naar het volgende onderdeel te navigeren."
        case .swipeLeft:
            return "Veeg met één vinger naar links, om naar het vorige onderdeel te navigeren."
        case .fourFingerTapTop:
            return "Tik met vier vingers bovenaan het scherm, om naar het eerste onderdeel te gaan."
        case .fourFingerTapBottom:
            return "Tik met vier vingers onderaan het scherm, om naar het laatste onderdeel te gaan."
        case .twoFingerSwipeUp:
            return "Veeg met twee vingers omhoog, om het volledig scherm voor te laten lezen."
        case .twoFingerSwipeDown:
            return "Veeg met twee vingers naar beneden, om het scherm vanaf het geselecteerde onderdeel voor te laten lezen."
        case .twoFingerTap:
            return "Tik met twee vingers op het scherm, om het voorlezen te pauzeren of te hervatten."
        case .threeFingerTap:
            return "Tik met drie vingers op het scherm, om extra informatie te laten voorlezen."
            
        case .scrollUp:
            return "Veeg met drie vingers omhoog, om één pagina omlaag te scrollen."
        case .scrollRight:
            return "Veeg met drie vingers naar rechts, om één pagina naar rechts te scrollen."
        case .scrollDown:
            return "Veeg met drie vingers omlaag, om één pagina omhoog te scrollen."
        case .scrollLeft:
            return "Veeg met drie vingers naar links, om één pagina naar links te scrollen."
            
        case .doubleTap:
            return "Tik tweemaal om het geselecteerde onderdeel te activeren."
        case .tripleTap:
            return "Tik driemaal om te dubbeltikken op het geselecteerde onderdeel."
        case .slide:
            return "Dubbeltik en houd vast tot je een toon hoort. Beweeg vervolgens je vinger naar links of rechts om de waarde van de schuifknop aan te passen."
        case .magicTap:
            return "Dubbeltik met twee vingers om de actuele handeling te starten of stoppen."
        case .escape:
             return "Zigzag met twee vingers in de vorm van een 'z', om een melding te sluiten of terug te gaan naar het vorige scherm."
        case .label:
            return "Dubbeltik met twee vingers en houdt vast om het label van een onderdeel te wijzigen."
            
        case .threeFingerDoubleTap:
            return "Tik tweemaal met drie vingers om het geluid van VoiceOver in- of uit te schakelen"
        case .threeFingerTripleTap:
            return "Tik driemaal met drie vingers om het schermgordijn in- of uit te schakelen"
        case .doubleTapLongPress:
            return "Dubbeltik en houd vast tot je een toon hoort. Voer vervolgens het gewenste gebaar uit."
        case .twoFingerTripleTap:
            return "Tik driemaal met twee vingers om de onderdeelkiezer te openen"
            
        case .rotor:
            return "Draai met twee vingers, om de rotorinstelling te kiezen."
        case .swipeUp:
            return "Veeg met één vinger omhoog, om het rotoronderdeel omhoog aan te passen."
        case .swipeDown:
            return "Veeg met één vinger omlaag, om het rotoronderdeel omlaag aan te passen."
        }
    }
    
    /** View to test the gesture */
    var view: GestureView {
        switch self {
        case .touch:
            return TouchGestureView(gesture: self, numberOfTaps: 1)
        case .swipeRight:
            return SwipeGestureView(gesture: self, direction: .right)
        case .swipeLeft:
            return SwipeGestureView(gesture: self, direction: .left)
        case .fourFingerTapTop:
            return TapGestureView(gesture: self, numberOfTaps: 1, numberOfFingers: 4, position: .top)
        case .fourFingerTapBottom:
            return TapGestureView(gesture: self, numberOfTaps: 1, numberOfFingers: 4, position: .bottom)
        case .twoFingerSwipeUp:
            return SwipeGestureView(gesture: self, direction: .up, numberOfFingers: 2)
        case .twoFingerSwipeDown:
            return SwipeGestureView(gesture: self, direction: .down, numberOfFingers: 2)
        case .twoFingerTap:
            return TapGestureView(gesture: self, numberOfTaps: 1, numberOfFingers: 2)
        case .threeFingerTap:
            return TapGestureView(gesture: self, numberOfTaps: 1, numberOfFingers: 3)
        
        case .scrollUp:
            return SwipeGestureView(gesture: self, direction: .up, numberOfFingers: 3)
        case .scrollRight:
            return SwipeGestureView(gesture: self, direction: .right, numberOfFingers: 3)
        case .scrollDown:
            return SwipeGestureView(gesture: self, direction: .down, numberOfFingers: 3)
        case .scrollLeft:
            return SwipeGestureView(gesture: self, direction: .left, numberOfFingers: 3)
            
        case .doubleTap:
            return TapGestureView(gesture: self, numberOfTaps: 2)
        case .tripleTap:
            return TapGestureView(gesture: self, numberOfTaps: 3)
        case .slide:
            return SlideGestureView(gesture: self)
        case .magicTap:
            return TapGestureView(gesture: self, numberOfTaps: 2, numberOfFingers: 2)
        case .escape:
            return EscapeGestureView(gesture: self)
        case .label:
            return LongPressGestureView(gesture: self, numberOfTaps: 1, numberOfFingers: 2, minimumDuration: 2.0)
            
        case .threeFingerDoubleTap:
            return TapGestureView(gesture: self, numberOfTaps: 2, numberOfFingers: 3)
        case .threeFingerTripleTap:
            return TapGestureView(gesture: self, numberOfTaps: 3, numberOfFingers: 3)
        case .doubleTapLongPress:
            return DefaultGestureView(gesture: self)
        case .twoFingerTripleTap:
            return TapGestureView(gesture: self, numberOfTaps: 3, numberOfFingers: 2)
            
        case .rotor:
            return RotationGestureView(gesture: self, rotation: 0.5)
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
