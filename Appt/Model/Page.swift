//
//  Page.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 07/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import Foundation
import WebKit

protocol Page {
    var url: String { get set }
    var title: String? { get set }
}
