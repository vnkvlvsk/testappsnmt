//
//  StorageService.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Foundation

final class StorageService: StorageServiceProtocol {
    
    static let shared: StorageServiceProtocol = StorageService()
    
    private let favoritesKey = "favoritesArticles"
    private let blockedKey = "blockedArticles"
    
    private init() {}
    
    func saveFavoriteNews(_ news: [NewsItem]) {
        guard let encoded = try? JSONEncoder().encode(news) else { return }
        UserDefaults.standard.set(encoded, forKey: favoritesKey)
    }
    
    func loadFavoriteNews() -> [NewsItem] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let decoded = try? JSONDecoder().decode([NewsItem].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func saveBlockedNews(_ articles: [NewsItem]) {
        guard let encoded = try? JSONEncoder().encode(articles) else { return }
        UserDefaults.standard.set(encoded, forKey: blockedKey)
    }
    
    func loadBlockedNews() -> [NewsItem] {
        guard let data = UserDefaults.standard.data(forKey: blockedKey),
              let decoded = try? JSONDecoder().decode([NewsItem].self, from: data) else {
            return []
        }
        return decoded
    }
}
