//
//  ContentView.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var contentViewModel = ContentViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject private var alertManager = AlertManager.shared
    
    var body: some View {
        NavigationStack {
            NewsView(newsViewModel: NewsViewModel())
        }
        .onAppear {
            contentViewModel.setupNavBarAppearance()
        }
        .onReceive(networkMonitor.$isConnected) { isConnected in
            if !isConnected {
                alertManager.show(.init(title: "No Internet Connection", primaryAction: .default(Text("OK"))))
            }
        }
        .alert(item: $alertManager.alert, content: AlertManager.handle)
    }
}
