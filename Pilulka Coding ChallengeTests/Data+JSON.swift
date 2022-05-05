//
//  Data+JSON.swift
//  Pilulka Coding ChallengeTests
//
//  Created by Nikita Khomitsevych on 05.05.2022.
//

import Foundation

extension Data {
    static func responseJSON(forResource resource: String, withExtension ext: String = "json") -> Data {
        guard let url = Bundle.tests.url(forResource: resource, withExtension: ext) else {
            fatalError("\(resource).\(ext) resource's URL is not gained")
        }
        guard let data = try? String(contentsOf: url).data(using: .utf8) else {
            fatalError("data parsed from \(resource).\(ext) is not gained")
        }
        return data
    }
}

