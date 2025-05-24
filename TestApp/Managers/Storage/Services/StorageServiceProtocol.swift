//
//  StorageServiceProtocol.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Foundation

protocol StorageServiceProtocol {
    func saveFavoriteNews(_ news: [NewsItem])
    func loadFavoriteNews() -> [NewsItem]
    
    func saveBlockedNews(_ news: [NewsItem])
    func loadBlockedNews() -> [NewsItem]
}
