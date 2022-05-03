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
        do {
            try network
                .getAllStates()
                .sink { _ in /*print("network method getAllStates() has been called from ViewModel")*/ }
                .store(in: &subscriptions)
        } catch {
//            print("some error has caught in ViewModel")
        }
    }
    
    private let network: Networking
    private var subscriptions = Set<AnyCancellable>()
}
