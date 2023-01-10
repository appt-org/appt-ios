//
//  WebPage.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 07/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import Foundation
import CoreData
import WebKit

public class WebPage: NSManagedObject, Page {
    
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var url: String
    @NSManaged public var title: String?
    
}
