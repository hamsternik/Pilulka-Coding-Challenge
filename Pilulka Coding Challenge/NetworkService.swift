//
//  NetworkService.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 07.05.2022.
//

import Combine
import Foundation

typealias RequestableResultPublisher = AnyPublisher<Data, NetworkError>

protocol Requestable {
    func getAllStates(
        lamin: Double,
        lomin: Double,
        lamax: Double,
        lomax: Double
    ) -> RequestableResultPublisher
    
    func getFlightsAircraft(
        icao24: String,
        begin: Int,
        end: Int
    ) -> RequestableResultPublisher
}

enum NetworkError: LocalizedError {
    case brokenURL(URLError.Code)
    case sessionError(Error)
    
    var localizedDescription: String {
        switch self {
        case .brokenURL:
            return "Network::Error::BrokenURL"
        case .sessionError(let error):
            return "Network::Error::URLSession. Details: \(error.localizedDescription)"
        }
    }
}

// MARK: - Network Service Implementation

struct NetworkService {
    private let session = URLSession.shared
    private let baseURL = URL(string: "https://opensky-network.org/api")!
    
    private func makeURLRequest<Request: Pilulka_Coding_Challenge.Request>(
        from request: Request
    ) -> RequestableResultPublisher {
        guard let endpointURL = baseURL
                /// URL method `appendingPathComponent` transforms string URL encoding path query chars like `?`
                .appendingPathComponent(request.path)
                .removingPercentEncodingFromAbsolute
        else {
            return .empty
                .mapError { _ in NetworkError.brokenURL(.badURL) }
                .eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: endpointURL)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        return session
            .dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .mapError { NetworkError.sessionError($0) }
            .eraseToAnyPublisher()
    }
}

extension NetworkService: Requestable {
    func getAllStates(
        lamin: Double = 48.55,
        lomin: Double = 12.9,
        lamax: Double = 51.06,
        lomax: Double = 18.87
    ) -> RequestableResultPublisher {
        makeURLRequest(
            from: GetAllVectorStatesRequest(
                latitudeMin: lamin,
                longitudeMin: lomin,
                latitudeMax: lamax,
                longitudeMax: lomax
            )
        )
    }
    
    func getFlightsAircraft(
        icao24: String,
        begin: Int,
        end: Int
    ) -> RequestableResultPublisher {
        makeURLRequest(
            from: GetAircraftFlightsRequest(
                icao24: icao24,
                beginTimeInSeconds: begin,
                endTimeInSeconds: end
            )
        )
    }
}

struct EmptyRequestable: Requestable {
    func getAllStates(
        lamin: Double,
        lomin: Double,
        lamax: Double,
        lomax: Double
    ) -> RequestableResultPublisher { .empty }
    
    func getFlightsAircraft(
        icao24: String,
        begin: Int,
        end: Int
    ) -> RequestableResultPublisher { .empty }
}

// MARK: -

extension URL {
    var removingPercentEncodingFromAbsolute: Self? {
        guard let decodedAbsoluteString = absoluteString.removingPercentEncoding else { return nil }
        return URL(string: decodedAbsoluteString)
    }
}

private extension AnyPublisher where Output == Data, Failure == NetworkError {
    static var empty: AnyPublisher<Output, Failure> { Empty<Data, NetworkError>().eraseToAnyPublisher() }
}
