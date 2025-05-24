//
//  NavigationItem.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Foundation

struct NavigationItem: Identifiable {
    let id: String
    let title: String
    let titleSymbol: String?
    let subtitle: String?
    let buttonTitle: String
    let buttonSymbol: String?
    let navigation: NavigationType
    
    enum NavigationType: String, Codable {
        case push
        case modal
        case fullScreen = "full_screen"
    }
}
