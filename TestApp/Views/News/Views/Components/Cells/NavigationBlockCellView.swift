//
//  NavigationBlockCellView.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

struct NavigationBlockView: View {
    
    let block: NavigationItem
    
    var didPressButton: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            
            if let symbol = block.titleSymbol {
                Image(systemName: symbol)
                    .font(.system(size: 20, weight: .thin))
                    .foregroundColor(.baseBlue)
            }
            
            Text(block.title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.baseBlack)
            
            if let subtitle = block.subtitle {
                Text(subtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.baseGrey)
                    .multilineTextAlignment(.center)
            }
                        
            Button {
                didPressButton()
            } label: {
                ZStack {
                    Text(block.buttonTitle)
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                    
                    if let symbol = block.buttonSymbol {
                        HStack {
                            Spacer()
                            Image(systemName: symbol)
                                .font(.system(size: 20, weight: .thin))
                        }
                        .padding(.trailing, 16)
                    }
                }
                .frame(height: 44)
                .background(.baseBlue)
                .foregroundColor(.white)
                .clipShape(.rect(cornerRadius: 4))
            }
            
        }
        .padding(.vertical, 12).padding(.horizontal, 16)
        .background(.white)
        .clipShape(.rect(cornerRadius: 8))
    }
}
