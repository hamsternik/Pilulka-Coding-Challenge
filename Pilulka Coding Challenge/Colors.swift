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
    
    public static var appPrimary: Color {
        Color("Primary", bundle: .main)
    }
    
    public static var background: Color {
        Color("Background", bundle: .main)
    }
}
