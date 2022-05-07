//
//  RequestTests.swift
//  Pilulka Coding ChallengeTests
//
//  Created by Nikita Khomitsevych on 07.05.2022.
//

import Foundation
import XCTest

@testable import Pilulka_Coding_Challenge


final class RequestTests: XCTestCase {
    func testGetAllVectorStatesRequestReturnsCorrectPath() {
        let request = GetAllVectorStatesRequest(latitudeMin: 48.55, longitudeMin: 12.9, latitudeMax: 51.06, longitudeMax: 18.87)
        let expectedRequestPath = "/states/all?lamin=48.55&lomin=12.9&lamax=51.06&lomax=18.87"
        XCTAssertEqual(request.path, expectedRequestPath)
    }
    
    func testGetAircraftFlightRequestReturnsCorrectPath() {
        let request = GetAircraftFlightsRequest(icao24: "3c4b31", beginTimeInSeconds: 1650747600, endTimeInSeconds: 1650834000)
        let expectedRequestPath = "/flights/aircraft?icao24=3c4b31&begin=1650747600&end=1650834000"
        XCTAssertEqual(request.path, expectedRequestPath)
    }
}
