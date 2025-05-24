//
//  NavigationPushView.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

struct NavigationPushView: View {
    
    let navigationItem: NavigationItem
    
    var body: some View {
        VStack {
            Spacer()
            Text(navigationItem.subtitle ?? "")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.baseGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Spacer()
        }
        .navigationTitle(navigationItem.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
