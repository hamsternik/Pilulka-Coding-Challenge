//
//  CountryFlagView.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 29.04.2022.
//

import SwiftUI

struct CountryFlagView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: containerSide, height: containerSide, alignment: .center)
                .foregroundColor(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: containerRadius, style: .circular)
                        .stroke(Color.appPrimary)
                )
            Text(flag)
                .font(.title)
        }
    }
    
    init(flag: String) {
        self.flag = flag
    }
    
    private let flag: String
    private let containerRadius: CGFloat = 22
    private var containerSide: CGFloat { containerRadius * 2 }
}

struct CountryFlagView_Previews: PreviewProvider {
    static var previews: some View {
        CountryFlagView(flag: "🇺🇦")
    }
}

