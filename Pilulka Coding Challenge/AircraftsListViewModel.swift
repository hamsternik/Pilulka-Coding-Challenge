//
//  AircraftsListViewModel.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 03.05.2022.
//

import Combine

final class AircraftsListViewModel: ObservableObject {
    init(network: Networking) {
        self.network = network
    }
    
    func initialiseIfRequired() {
        network
            .getAllStates()
            .sink(receiveCompletion: { error in
                print(String(describing: error))
            }, receiveValue: {
                do {
                    self.stateVectors = try StateVectors(from: $0)
                } catch {
                    print("AircraftsListViewModel::Error due StateVectors parsing: \(error)")
                }
            })
            .store(in: &subscriptions)
    }
    
    private let network: Networking
    private var stateVectors: StateVectors = .empty
    private var subscriptions = Set<AnyCancellable>()
}
