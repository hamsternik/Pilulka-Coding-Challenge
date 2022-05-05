//
//  Network.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 03.05.2022.
//

import Combine
import Foundation

// MARK: -

typealias AllStatesGETPublisher = AnyPublisher<Data, NetworkError>

protocol Networking {
    func getAllStates() -> AllStatesGETPublisher
}

struct Network: Networking {
    func getAllStates() -> AllStatesGETPublisher {
        let params = ["lamin": "48.55", "lomin": "12.9", "lamax": "51.06", "lomax": "18.87"]
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "opensky-network.org"
        components.path = "/api/states/all"
        components.setQuery(with: params)
        
        guard let url = components.url?.absoluteURL else {
            return Just(.init())
                .mapError { _ in NetworkError.brokenURL }
                .eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: url)
            .map { data, response in data }
            .mapError { NetworkError.sessionError($0) }
            .eraseToAnyPublisher()
    }
    
    private let session = URLSession.shared
    private var baseURL: URL? { URL(string: "https://opensky-network.org/api") }
}

struct MockNetwork: Networking {
    func getAllStates() -> AllStatesGETPublisher {
        return Just(Data()).mapError { _ in .brokenURL }.eraseToAnyPublisher()
    }
}

// MARK: -

enum NetworkError: LocalizedError {
    case brokenURL
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

private extension URLComponents {
    mutating func setQuery(with params: [String: String]) {
        queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
