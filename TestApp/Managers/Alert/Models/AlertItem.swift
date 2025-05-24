//
//  AlertItem.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id: UUID = UUID()
    let title: String
    var message: String? = nil
    let primaryAction: Alert.Button
    var secondaryAction: Alert.Button? = nil
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
