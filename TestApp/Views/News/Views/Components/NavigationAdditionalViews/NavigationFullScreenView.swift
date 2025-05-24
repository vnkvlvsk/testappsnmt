//
//  NavigationFullScreenView.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

struct NavigationFullScreenView: View {
    @Binding var isShowView: Bool
    let navigationItem: NavigationItem
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 8) {
                Text(navigationItem.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.baseBlack)
                
                Text(navigationItem.subtitle ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.baseGrey)
                
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
