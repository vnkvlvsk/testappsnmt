//
//  NewsCellView.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

struct NewsCellView: View {
    
    let news: NewsItem
    let isInFavorite: Bool
    let segmentState: NewsViewModel.ListPickerSegment
    
    var didTapCell: () -> Void
    var didTapAddToFavourites: (() -> Void)?
    var didTapBlock: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                didTapCell()
            } label: {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "newspaper.fill")
                        .foregroundColor(.baseBlue)
                        .frame(width: 94, height: 86)
                        .background(.baseBeige)
                        .clipShape(.rect(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(news.webTitle)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.baseBlack)
                            .lineLimit(3)
                        
                        HStack(spacing: 4) {
                            Text(news.sectionName)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.baseGrey)
                            Circle()
                                .fill(.baseGrey)
                                .frame(width: 4, height: 4)
                            Text(formattedDate(news.webPublicationDate))
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.baseGrey)
                        }
                    }
                    .padding(.trailing, 16)
                    
                    Spacer()
                }
                .padding(12)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 8))
            }
            
            Menu {
                switch segmentState {
                case .all:
                    Button {
                        didTapAddToFavourites?()
                    } label: {
                        Label(isInFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: "heart")
                    }
                    Button(role: .destructive) {
                        didTapBlock()
                    } label: {
                        Label("Block", systemImage: "nosign")
                    }
                case .favorites:
                    Button {
                        didTapAddToFavourites?()
                    } label: {
                        Label("Remove from Favorites", systemImage: "heart")
                    }
                    Button(role: .destructive) {
                        didTapBlock()
                    } label: {
                        Label("Block", systemImage: "nosign")
                    }
                case .blocked:
                    Button(role: .destructive) {
                        didTapBlock()
                    } label: {
                        Label("Unblock", systemImage: "nosign")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.baseGrey)
                    .padding(12)
            }
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 8))
    }
    
    private func formattedDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d, yyyy"
            return outputFormatter.string(from: date)
        }
        return isoDate
    }
}
