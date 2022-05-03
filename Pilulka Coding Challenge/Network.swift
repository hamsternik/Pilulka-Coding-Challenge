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
                    
                    let stateVectors = try decoder.decode(StateVectors.self, from: data)
//                    print(">> StateVectors array LOG\n\(stateVectors)")
                    return
                } catch {
//                    print(">> Networking • caught error: \(error)")
                    return
                }
            }
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
    
    private let session = URLSession.shared
    private var baseURL: URL? {
        URL(string: "https://opensky-network.org/api")
    }
}

struct MockNetwork: Networking {
    func getAllStates() throws -> AnyPublisher<Void, Never> {
        .empty.eraseToAnyPublisher()
    }
}

// MARK: -

struct StateVectors {
    struct Vector {
        enum PositionSource: Int, CustomStringConvertible {
            case adsb, asterix, mlat, flarm

            var description: String {
                switch self {
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
        let sensors: [Int]?
        let geoAltitude: Double?
        let squawk: String?
        let spi: Bool
        let positionSource: PositionSource
    }
    
    let time: Int
    let states: [[WrappedValue]]
}

extension StateVectors: Decodable {}
extension StateVectors.Vector: Decodable {}
extension StateVectors.Vector.PositionSource: Decodable {}

// MARK:

enum WrappedValue {
    case int(Int?)
    case double(Double?)
    case string(String?)
    case boolean(Bool?)
    case intArray([Int]?)
    case null
}

extension WrappedValue: Decodable {
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
            WrappedValue.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for WrappedValue")
        )
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
