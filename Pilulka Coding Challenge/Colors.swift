//
//  Color.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 22.04.2022.
//

import SwiftUI

extension Color {
    public static var appAccentColor: Color {
        Color("AccentColor", bundle: .main)
    }
    
    public static var primary: Color {
        Color("Primary", bundle: .main)
    }
}
