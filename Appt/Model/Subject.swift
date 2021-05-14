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
    private let url: String

    var imgURL: URL? {
        URL(string: self.image)
    }

    var webURL: URL? {
        URL(string: self.url)
    }

    var subjectType: SubjectType {
        guard let type = SubjectType(rawValue: self.type) else { fatalError("unknown subjectType") }

        return type
    }

    static func loadJson() -> Subject {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else { fatalError() }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(Subject.self, from: data)
            return jsonData
        } catch {
            fatalError()
        }
    }
}
