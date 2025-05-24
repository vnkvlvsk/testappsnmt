//
//  FeedItem.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Foundation

enum FeedItem: Identifiable {
    case news(NewsItem)
    case navigation(NavigationItem, Int)

    var id: String {
        switch self {
        case .news(let news):
            return "news-\(news.id)"
        case .navigation(let navigation, let index):
            return "navigation-\(navigation.id)-\(index)"
        }
    }
}
