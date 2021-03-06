//
//  ModelsTests.swift
//  Pilulka Coding ChallengeTests
//
//  Created by Nikita Khomitsevych on 05.05.2022.
//

import XCTest
import Combine

@testable import Pilulka_Coding_Challenge

final class ModelsTests: XCTestCase {
    func testAllStatesResponseBodyParsedAtStateVectorsCorrect() {
        let responseJSON = Data.responseJSON(
            forResource: "StatesAllGETResponseBody",
            withExtension: "json"
        )
        let stateVectors = try? StateVectors(from: responseJSON)
        XCTAssertNotNil(stateVectors)
    }
    
    func testFlightsAircraftResponseBodyParsedIntoFlights() {
        let resource = "GETFlightsAircraftResponseBody"
        let data = Data.responseJSON(forResource: resource)
        let model = try? ResponseBody.FlightsAircraftGET.decode(from: data)
        XCTAssertNotNil(model)
    }
}
