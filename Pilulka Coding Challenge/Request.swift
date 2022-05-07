//
//  Request.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 07.05.2022.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST
}

protocol Request {
    associatedtype Response
    
    var method: HTTPMethod { get }
    var path: String { get }
    var httpHeaders: [String: String] { get }
    var body: Data? { get }
    
    func handle(from data: Data) throws -> Response
}

struct GetAllVectorStatesRequest: Request {
    typealias Response = StateVectors
    
    let latitudeMin: Double
    let longitudeMin: Double
    let latitudeMax: Double
    let longitudeMax: Double
    
    private let paramNames = ["lamin", "lomin", "lamax", "lomax"]
    
    var method: HTTPMethod { .GET }
    var httpHeaders: [String: String] { [:] }
    var body: Data? { nil }
    
    var path: String {
        let endpointPath = "/states/all"
        var components = URLComponents()
        components.path = endpointPath
        components.queryItems = queryParams
        return components.path + "?" + (components.query ?? "")
    }
    
    private var queryParams: [URLQueryItem] {
        let paramValues = [latitudeMin, longitudeMin, latitudeMax, longitudeMax]
        let queryParams = zip(paramNames, paramValues).map { (name, value) in (name, String(value)) }
        return queryParams.map { (name, value) in URLQueryItem(name: name, value: value) }
    }
    
    func handle(from data: Data) throws -> Response {
        try StateVectors(from: data)
    }
}

struct GetAircraftFlightsRequest: Request {
    typealias Response = [ResponseBody.FlightsAircraftGET]
    
    let icao24: String
    let beginTimeInSeconds: Int
    let endTimeInSeconds: Int
    
    private let paramNames = ["icao24", "begin", "end"]
    
    var method: HTTPMethod { .GET }
    var httpHeaders: [String: String] { [:] }
    var body: Data? { nil }
    
    var path: String {
        let endpointPath = "/flights/aircraft"
        var components = URLComponents()
        components.path = endpointPath
        components.queryItems = queryParams
        return components.path + "?" + (components.query ?? "")
    }
    
    func handle(from data: Data) throws -> Response {
        try ResponseBody.FlightsAircraftGET.decode(from: data)
    }
    
    private var queryParams: [URLQueryItem] {
        var paramValues = [icao24]
        paramValues.append(
            contentsOf: [beginTimeInSeconds, endTimeInSeconds].map { String($0) }
        )
        let queryParams = zip(paramNames, paramValues)
        return queryParams.map { (name, value) in URLQueryItem(name: name, value: value) }
    }
}
