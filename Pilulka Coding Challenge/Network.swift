//
//  Network.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 03.05.2022.
//

import Combine
import Foundation
import UserNotifications

protocol Networking {
    func getAllStates() throws -> AnyPublisher<Void, Never>
}

struct Network: Networking {
    func getAllStates() throws -> AnyPublisher<Void, Never> {
        let params = ["lamin": "48.55", "lomin": "12.9", "lamax": "51.06", "lomax": "18.87"]
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "opensky-network.org"
        components.path = "/api/states/all"
        components.setQuery(with: params)
        
        guard let url = components.url?.absoluteURL else {
            return .empty.eraseToAnyPublisher()
        }
        print("request URL: \(url)")
        
        return session.dataTaskPublisher(for: url)
            .map { data, response in
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    print(">> encoded data: \(String(data: data, encoding: .utf8) ?? "")")
                    
                    let model = try decoder.decode(AllStatesModel.self, from: data)
//                    print(">> decoded /all/states model\n\(model)\n")
                    
                    let stateVectors = StateVectors(time: model.time, states: model.states.map(\.stateVector))
//                    print(">> stateVectors\n\(stateVectors)\n")
                    
                    return
                } catch {
                    print(">> Networking • error: \(error)")
                    return
                }
            }
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
    
    private let session = URLSession.shared
    private var baseURL: URL? { URL(string: "https://opensky-network.org/api") }
}

struct MockNetwork: Networking {
    func getAllStates() throws -> AnyPublisher<Void, Never> {
        .empty.eraseToAnyPublisher()
    }
}

// MARK: -

struct AllStatesModel: Decodable {
    enum WrappedValue: Decodable {
        case int(Int?)
        case double(Double?)
        case string(String?)
        case boolean(Bool?)
        case intArray([Int]?)
        case null
        
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
    
    let time: Int
    let states: [[WrappedValue]]
}

extension Array where Element == AllStatesModel.WrappedValue {
    var stateVector: StateVectors.Vector {
        let keysAndValues = Array<(String, AllStatesModel.WrappedValue)>(zip(wrappedValueKeys, self))
        let wrappedValuesDict = keysAndValues.reduce([String: AllStatesModel.WrappedValue]()) {
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

// MARK:

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
}

extension StateVectors.Vector {
    init(from dict: [String: AllStatesModel.WrappedValue]) {
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

// MARK: -

extension URLComponents {
    mutating func setQuery(with params: [String: String]) {
        queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

extension AnyPublisher {
    static var empty: AnyPublisher<Void, Never> {
        AnyPublisher<Void, Never>(Just(()))
    }
}
