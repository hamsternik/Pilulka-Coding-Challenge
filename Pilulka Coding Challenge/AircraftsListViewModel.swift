//
//  AircraftsListViewModel.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 03.05.2022.
//

import Combine

final class AircraftsListViewModel: ObservableObject {
    init(networkService: Requestable = NetworkService()) {
        self.networkService = networkService
    }
    
    func initialiseIfRequired() {
        networkService
            .getAllStates(lamin: 48.55, lomin: 12.9, lamax: 51.06, lomax: 18.87)
            .sink(receiveCompletion: { error in
                print(String(describing: error))
            }, receiveValue: {
                do {
                    self.stateVectors = try StateVectors(from: $0)
                    print(">> \(Self.self)::success\n")
                } catch {
                    print(">> \(Self.self)::failure\nError from `GET /all/states`: \(error)")
                }
            })
            .store(in: &subscriptions)
        
        // TODO call `networkService.getFlightsAircraft(:)`
    }
    
    private let networkService: Requestable
    private var stateVectors: StateVectors = .empty
    private var subscriptions = Set<AnyCancellable>()
}
