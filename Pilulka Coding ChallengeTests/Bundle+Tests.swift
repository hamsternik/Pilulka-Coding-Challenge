//
//  Bundle+Tests.swift
//  Pilulka Coding ChallengeTests
//
//  Created by Nikita Khomitsevych on 05.05.2022.
//

import Foundation

extension Bundle {
    final class TestsBundle {
        static var `default`: Bundle { Bundle(for: Self.self) }
    }
    
    static var tests: Bundle { TestsBundle.default }
}
