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
    
    /** Explanation of the gesture */
    var explanation: String {
        switch self {
        case .touch:
            return "Wanneer je het scherm aanraakt wordt de inhoud onder je vinger voorgelezen.\n\nTip: als je vervolgens met een andere vinger op het scherm tikt, voer je direct een dubbeltik uit."
        case .swipeRight:
            return "Door naar rechts te vegen verken je het scherm van boven naar beneden, van links naar rechts."
        case .swipeLeft:
            return "Door naar links te vegen verken je het scherm van rechts naar links, van beneden naar boven."
        case .fourFingerTapTop:
            return "Het kan handig zijn om naar de bovenkant van het scherm te verspringen. Meestal zit hier de terugknop.\n\nDit gebaar is lastig om uit te voeren op kleine schermen. Je hoeft niet de vingers van dezelfde hand te gebruiken. Je kunt ookt twee vingers van je linkerhand en twee vingers van je rechterhand gebruiken."
        case .fourFingerTapBottom:
            return "Het kan handig zijn om naar de onderkant van het scherm te verspringen. Meestal zit hier een manier om te navigeren.\n\nDit gebaar is lastig om uit te voeren op kleine schermen. Je hoeft niet de vingers van dezelfde hand te gebruiken. Je kunt ookt twee vingers van je linkerhand en twee vingers van je rechterhand gebruiken."
        case .twoFingerSwipeUp:
            return "Dit gebaar kan van pas komen als je bijvoorbeeld een webpagina in zijn geheel laten voorlezen. Tik met twee vingers om te scherm om het voorlezen te stoppen."
        case .twoFingerSwipeDown:
            return "Dit gebaar kan van pas komen als je de rest van de inhoud wilt laten voorlezen. Tik met twee vingers om te scherm om het voorlezen te stoppen."
        case .twoFingerTap:
            return "Dit gebaar is belangrijk om te onthouden, zodat je VoiceOver kan pauzeren wanneer je wilt."
        case .threeFingerTap:
            return "Dit gebaar kan handig zijn ter oriëntatie waar je op het scherm bent."
            
        case .scrollUp:
            return "Gebruik dit gebaar wanner je omlaag wilt scrollen."
        case .scrollRight:
            return "Gebruik dit gebaar wanner je naar rechts wilt scrollen."
        case .scrollDown:
            return "Gebruik dit gebaar wanner je omhoog wilt scrollen."
        case .scrollLeft:
            return "Gebruik dit gebaar wanner je naar links wilt scrollen."
            
        case .doubleTap:
            return "Dit gebaar gebruik je om bijvoorbeeld een knop te activeren."
        case .tripleTap:
            return "Dit gebaar wordt door sommige apps gebruikt om bijvoorbeeld een menu te tonen."
        case .slide:
            return "Met dit gebaar kun je bijvoorbeeld het volume op de exacte waarde instellen die je wilt.\n\nTip: je kunt ook omlaag of omhoog vegen om de waarde in stappen in te stellen."
        case .magicTap:
            return "Dit gebaar is ook bekend als Magic Tap. Hiermee kun je bijvoorbeeld muziek op de achtergrond starten of stoppen. Sommige apps gebruiken dit ook gebaar om de belangrijkste actie op het scherm uit te voeren."
        case .escape:
             return "Dit gebaar is superhandig. Je kunt namelijk vanaf elke plek in een app terug navigeren. Daarnaast kun je meldingen sluiten.\n\nHet is vaak even wennen hoe je dit gebaar precies uitvoert. Je moet met twee vingers zigzaggen in de vorm van een Z."
        case .label:
            return "Helaas zijn niet alle apps toegankelijk. Dankzij dit gebaar kun je je eigen labels toevoegen. Handig om bijvoorbeeld knoppen aan te geven.\n\nLet op: na elke app update zijn al je labels weg. De ontwikkelaar van de app kan hier niks aan doen."
            
        case .threeFingerDoubleTap:
            return "Dit gebaar is belangrijk om te onthouden. Vaak wordt dit gebaar namelijk perongeluk gebruikt. Hoor je geen geluid meer? Tik dan tweemaal met drievingers om het geluid van VoiceOver weer aan te zetten!"
        case .threeFingerTripleTap:
            return "Indien je geen zicht meer hebt, kun je het schermgordijn inschakelen. Hierdoor verbbruikt je telefoon minder stroom en kan er niemand op je scherm meekijken."
        case .doubleTapLongPress:
            return "Soms is het nodig om een standaardgebaar te maken. Hiermee wordt een gebaar bedoelt buiten VoiceOver om. Door dit gebaar te gebruiken, gaat de interactie direct naar de app en niet naar VoiceOver. Hierdoor is het bijvoorbeeld mogelijk om je handtekening te zetten."
        case .twoFingerTripleTap:
            return "De onderdeelkiezer kan het navigeren binnen een app makkelijker maken.\n\nTip: je kunt de onderdeelkiezer sluiten door met twee vingers te zigzaggen."
            
        case .rotor:
            return "Plaats twee vingers een stukje uit elkaar op het scherm. Maak vervolgens een draai beweging. Maak nog een draai beweging om naar het volgende onderdeel te gaan.\n\nHet kan lastig zijn om dit gebaar onder de knie te krijgen. De rotor is heel uitgebreid, dus onthoud dit gebaar goed!"
        case .swipeUp:
            return "Afhankelijk van het type rotoronderdeel wordt de waarde verhoogt, of ga je naar het volgende onderdeel."
        case .swipeDown:
            return "Afhankelijk van het type rotoronderdeel wordt de waarde verlaagt, of ga je naar het vorige onderdeel."
        }
    }
    
    /** View to execute the gesture */
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
    
    /** Completion state of the gesture */
    var completed: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: self.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: self.rawValue)
        }
    }
}
