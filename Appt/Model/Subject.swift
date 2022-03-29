//
//  Subject.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/13/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import Foundation

enum SubjectType: String {
    case blocks
    case list
}

struct Subject: Decodable {
    let title: String
    let description: String
    let image: String
    var children: Array<Subject>
    private let type: String
    let url: String

    var imageURL: URL? {
        guard !image.isEmpty else {
            return nil
        }
        return URL(string: image)
    }

    var subjectType: SubjectType {
        guard let type = SubjectType(rawValue: self.type) else { fatalError("unknown subjectType") }

        return type
    }
}
