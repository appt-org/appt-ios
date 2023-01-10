//
//  History.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 07/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import Foundation
import CoreData

public class History: WebPage {
    
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }
}
