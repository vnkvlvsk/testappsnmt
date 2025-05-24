//
//  AlertManager.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

final class AlertManager: ObservableObject {
    @Published var alert: AlertItem?
    static let shared = AlertManager()
    
    private init() {}

    func show(_ alert: AlertItem) {
        self.alert = alert
    }
    
    static func handle(for item: AlertItem) -> Alert {
        if let secondaryAction = item.secondaryAction {
            return Alert(
                title: Text(item.title),
                message: Self.getMessage(item.message),
                primaryButton: item.primaryAction,
                secondaryButton: secondaryAction
            )
        } else {
            return Alert(
                title: Text(item.title),
                message: Self.getMessage(item.message),
                dismissButton: item.primaryAction
            )
        }
    }
    
    private static func getMessage(_ message: String?) -> Text? {
        if let message = message {
            return Text(message)
        } else {
            return nil
        }
    }
}

