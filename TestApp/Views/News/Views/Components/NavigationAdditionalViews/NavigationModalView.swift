//
//  NavigationModalView.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

struct NavigationModalView: View {
    @Binding var isShowView: Bool
    let navigationItem: NavigationItem
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                if let symbol = navigationItem.titleSymbol {
                    Image(systemName: symbol)
                        .font(.system(size: 40, weight: .thin))
                        .foregroundColor(.baseBlue)
                }
                
                Text(navigationItem.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.baseBlack)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            isShowView = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.baseBlue)
                    }
                }
            }
        }
    }
}
