//
//  StateVectors.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 05.05.2022.
//

import Foundation

struct StateVectors {
    struct Vector {
        enum PositionSource: Int, CustomStringConvertible {
            case none = -1, adsb, asterix, mlat, flarm

            var description: String {
                switch self {
                case .none: return "none"
                case .adsb: return "ADS-B"
                case .asterix: return "ASTERIX"
                case .mlat: return "MLAT"
                case .flarm: return "FLARM"
                }
            }
        }
        
        let icao24: String
        let callsign: String
        let originCountry: String
        let timePosition: Int
        let lastContact: Int
        let longitude: Double?
        let latitude: Double?
        let baroAltitude: Double?
        let onGround: Bool
        let velocity: Double?
        let trueTrack: Double?
        let verticalRate: Double?
        let sensors: [Int]
        let geoAltitude: Double?
        let squawk: String?
        let spi: Bool
        let positionSource: PositionSource
    }
    
    let time: Int
    let states: [Vector]
    
    static var empty = StateVectors(time: 0, states: [])
}

extension StateVectors {
    init(from data: Data) throws {
        let body = try ResponseBody.AllStatesGET.decode(from: data)
        self.time = body.time
        self.states = body.states.map(\.stateVector)
    }
}

extension StateVectors.Vector {
    init(from dict: [String: ResponseBody.AllStatesGET.WrappedValue]) {
        self.icao24 = dict["icao24"]?.stringValue ?? ""
        self.callsign = dict["callsign"]?.stringValue ?? ""
        self.originCountry = dict["origin_country"]?.stringValue ?? ""
        self.timePosition = dict["time_position"]?.intValue ?? 0
        self.lastContact = dict["last_contact"]?.intValue ?? 0
        self.longitude = dict["longitude"]?.doubleValue
        self.latitude = dict["latitude"]?.doubleValue
        self.baroAltitude = dict["baro_altitude"]?.doubleValue
        self.onGround = dict["on_ground"]?.boolValue ?? false
        self.velocity = dict["velocity"]?.doubleValue
        self.trueTrack = dict["true_track"]?.doubleValue
        self.verticalRate = dict["vertical_rate"]?.doubleValue
        self.sensors = dict["sensors"]?.intArrayValue ?? []
        self.geoAltitude = dict["geo_altitude"]?.doubleValue
        self.squawk = dict["squawk"]?.stringValue
        self.spi = dict["spi"]?.boolValue ?? false
        self.positionSource = PositionSource(rawValue: dict["position_source"]?.intValue ?? -1) ?? .none
    }
}

extension Array where Element == ResponseBody.AllStatesGET.WrappedValue {
    var stateVector: StateVectors.Vector {
        let keysAndValues = Array<(String, ResponseBody.AllStatesGET.WrappedValue)>(zip(wrappedValueKeys, self))
        let wrappedValuesDict = keysAndValues.reduce([String: ResponseBody.AllStatesGET.WrappedValue]()) {
            var newValue = $0
            newValue[$1.0] = $1.1
            return newValue
        }
        return .init(from: wrappedValuesDict)
    }
}

private let wrappedValueKeys: [String] = [
    "icao24", "callsign", "origin_country", "time_position", "last_contact", "longitude", "latitude", "baro_altitude",
    "on_ground", "velocity", "true_track", "vertical_rate", "sensors", "geo_altitude", "squawk", "spi", "position_source"
]
