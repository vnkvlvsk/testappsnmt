//
//  ContentViewModel.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    func setupNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .baseBeige
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.baseBlack
        ]
        
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold),
            .foregroundColor: UIColor.baseBlack
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
