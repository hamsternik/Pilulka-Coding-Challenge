//
//  FlightView.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 29.04.2022.
//

import SwiftUI

struct FlightView: View {
    var body: some View {
        HStack {
            CountryFlagView(flag: model.originCountry)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(model.departureTitle) -- \(model.arrivalTitle)")
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(model.firstSeen) -- \(model.lastSeen)")
                    .foregroundColor(.appPrimary)
                    .font(.footnote)
                    .fontWeight(.light)
            }
            Spacer()
            Text("by \(model.callsign)")
                .foregroundColor(.appPrimary)
                .font(.footnote)
                .fontWeight(.medium)
        }
        .padding()
        .background(.white)
        .contentShape(Rectangle())
        .cornerRadius(20)
    }
    
    init(model: FlightViewModel, onTap: (() -> Void)? = nil) {
        self.model = model
        self.onTap = onTap
    }
    
    private let model: FlightViewModel
    private let onTap: (() -> Void)?
}


struct FlightView_Previews: PreviewProvider {
    static var previews: some View {
        FlightView(model: mockFlight)
    }
}

// MARK: - Model

struct FlightViewModel: Equatable, Identifiable {
    let id = UUID()
    let callsign: String
    let originCountry: String
    let departureTitle: String
    let arrivalTitle: String
    let firstSeen: String
    let lastSeen: String
}

private let mockFlight = Flight(callsign: "WZZ1593", originCountry: "🇺🇦", departureTitle: "LGAV", arrivalTitle: "LLBG", firstSeen: "3:15pm", lastSeen: "5:45pm")
