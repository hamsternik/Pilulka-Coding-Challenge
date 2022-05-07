//
//  ResponseBody.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 05.05.2022.
//

import struct Foundation.Data
import class Foundation.JSONDecoder

/// Namespace for all response body models need to handle data explicitly.
enum ResponseBody {}

// MARK: - ResponseBody+AllStatesGET

extension ResponseBody {
    struct AllStatesGET: Decodable {
        enum WrappedValue: Decodable {
            case int(Int?)
            case double(Double?)
            case string(String?)
            case boolean(Bool?)
            case intArray([Int]?)
            case null
        }
        
        let time: Int
        let states: [[WrappedValue]]
        
        static var empty: AllStatesGET = .init(time: 0, states: [])
    }
}

extension ResponseBody.AllStatesGET {
    static func decode(from data: Data) throws -> ResponseBody.AllStatesGET {
        try decoder.decode(Self.self, from: data)
    }
    
    private static var decoder: JSONDecoder { JSONDecoder() }
}

// MARK: Custom Getters (WrappedValue)

extension ResponseBody.AllStatesGET.WrappedValue {
    var intValue: Int? {
        guard case .int(let value) = self else { return nil }
        return value
    }
    
    var doubleValue: Double? {
        guard case .double(let value) = self else { return nil }
        return value
    }
    
    var stringValue: String? {
        guard case .string(let value) = self else { return nil }
        return value
    }
    
    var boolValue: Bool? {
        guard case .boolean(let value) = self else { return nil }
        return value
    }
    
    var intArrayValue: [Int]? {
        guard case .intArray(let value) = self else { return nil }
        return value
    }
}

// MARK: Custom Decodable (WrappedValue)

extension ResponseBody.AllStatesGET.WrappedValue {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .int(value)
            return
        }
        
        if let value = try? container.decode(Double.self) {
            self = .double(value)
            return
        }
        
        if let value = try? container.decode(String.self) {
            self = .string(value.trimmingCharacters(in: .whitespacesAndNewlines))
            return
        }
        
        if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
            return
        }
        
        if let value = try? container.decode([Int].self) {
            self = .intArray(value)
            return
        }
        
        if container.decodeNil() {
            self = .null
            return
        }
        
        throw DecodingError.typeMismatch(
            Self.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for WrappedValue")
        )
    }
}

// MARK: - ResponseBody+FlightsAircraftGET

extension ResponseBody {
    struct FlightsAircraftGET: Decodable {
        let icao24: String
        let firstSeen: Int
        let estDepartureAirport: String
        let lastSeen: Int
        let estArrivalAirport: String?
        let callsign: String
        let estDepartureAirportHorizDistance: Int
        let estDepartureAirportVertDistance: Int
        let estArrivalAirportHorizDistance: Int
        let estArrivalAirportVertDistance: Int
        let departureAirportCandidatesCount: Int
        let arrivalAirportCandidatesCount: Int
    }
}

extension ResponseBody.FlightsAircraftGET {
    static func decode(from data: Data) throws -> [Self] {
        try decoder.decode([Self].self, from: data)
    }
    
    private static var decoder: JSONDecoder { JSONDecoder() }
    
    static let empty = Self(
        icao24: "",
        firstSeen: 0,
        estDepartureAirport: "",
        lastSeen: 0,
        estArrivalAirport: nil,
        callsign: "",
        estDepartureAirportHorizDistance: 0,
        estDepartureAirportVertDistance: 0,
        estArrivalAirportHorizDistance: 0,
        estArrivalAirportVertDistance: 0,
        departureAirportCandidatesCount: 0,
        arrivalAirportCandidatesCount: 0
    )
}
