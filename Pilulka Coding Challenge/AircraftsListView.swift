//
//  AircraftsListView.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 28.04.2022.
//

import SwiftUI

struct AircraftsListView: View {
    let viewModel: AircraftsListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(0..<mockFlights.count) { index in
                            FlightView(model: mockFlights[index])
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                                .padding(.bottom, 8)
                        }
                    }
                }
            }
            .navigationBarTitle("Czech Republic Flights")
        }
        .onAppear {
            viewModel.initialiseIfRequired()
        }
    }
    
    init(viewModel: AircraftsListViewModel) {
        self.viewModel = viewModel
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
    }
    
    
}

struct AircraftsListView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftsListView(viewModel: .init(networkService: EmptyRequestable()))
    }
}

// MARK: - Model

// TODO move out into `ResponseBody`;
// TODO replace mock data with real response body model
typealias Flight = FlightViewModel
private let mockFlights: [Flight] = [
    Flight(callsign: "WZZ1593", originCountry: "πΊπ¦", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm"),
    Flight(callsign: "VOE17RJ", originCountry: "π­πΊ", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm"),
    Flight(callsign: "WZZ15XY", originCountry: "πΊπ¦", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm"),
    Flight(callsign: "DLH2YJ", originCountry: "π­πΊ", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm"),
    Flight(callsign: "471f02", originCountry: "πΊπ¦", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm"),
    Flight(callsign: "CAI15LR", originCountry: "π­πΊ", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm"),
    Flight(callsign: "471f02", originCountry: "πΊπ¦", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm"),
    Flight(callsign: "DLH2YJ", originCountry: "π­πΊ", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm"),
]
