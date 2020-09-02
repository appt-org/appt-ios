//
//  VoiceOverHeadingsView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverHeadingsView: VoiceOverView {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var instructions: UILabel!
    @IBOutlet var heading1: UILabel!
    @IBOutlet var text1: UILabel!
    @IBOutlet var heading2: UILabel!
    @IBOutlet var text2: UILabel!
    @IBOutlet var heading3: UILabel!
    @IBOutlet var text3: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.setCustomSpacing(32, after: instructions)
        stackView.setCustomSpacing(32, after: text1)
        stackView.setCustomSpacing(32, after: text2)
        
        instructions.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        
        heading1.font = .sourceSansPro(weight: .bold, size: 20, style: .body)
        text1.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        
        heading2.font = .sourceSansPro(weight: .bold, size: 20, style: .body)
        text2.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        
        heading3.font = .sourceSansPro(weight: .bold, size: 20, style: .body)
        text3.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        //let nibName = String(describing: T.self)
        let nibName = "VoiceOverHeadingsView"
        print("Nib name: \(nibName)")
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)![0] as! T
    }
}
