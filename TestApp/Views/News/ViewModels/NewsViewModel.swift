//
//  NewsViewModel.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI
import Combine

final class NewsViewModel: ObservableObject {
    @Published var selectedListSegment: ListPickerSegment = .all
    @Published var blockedNews: [NewsItem] = []
    @Published private var allNews: [NewsItem] = []
    @Published private var allNavigationBlocks: [NavigationItem] = []
    @Published private var allFavoriteNews: [NewsItem] = []
    
    @Published var isPushNavigation: (Bool, NavigationItem?) = (false, nil)
    @Published var isShowModalNavigation: (Bool, NavigationItem?) = (false, nil)
    @Published var isShowFullScreenNavigation: (Bool, NavigationItem?) = (false, nil)
    
    @Published var error: AlertItem? = nil
    
    var feedItems: [FeedItem] {
        let filteredNews = allNews.filter { news in
            !blockedNews.contains(where: { $0.id == news.id })
        }
        guard !allNavigationBlocks.isEmpty else {
            return filteredNews.map { FeedItem.news($0) }
        }
        
        var result: [FeedItem] = []
        for (index, news) in filteredNews.enumerated() {
            result.append(.news(news))
            if (index + 1) % 2 == 0 {
                let navIndex = (index / 2) % allNavigationBlocks.count
                let navBlock = allNavigationBlocks[navIndex]
                result.append(.navigation(navBlock, index/2))
            }
        }
        print(result.count)
        return result
    }
    
    var favoriteNews: [NewsItem] {
        allFavoriteNews.filter { news in
            !blockedNews.contains(where: { $0.id == news.id })
        }
    }
    
    private var currentPage = 1
    private var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let service: FetchAPIServiceProtocol
    private let storage: StorageServiceProtocol
    private let alertManager: AlertManager
    
    init(
        service: FetchAPIServiceProtocol = FetchAPIService(),
        storage: StorageServiceProtocol = StorageService.shared,
        alertManager: AlertManager = AlertManager.shared
    ) {
        self.service = service
        self.storage = storage
        self.alertManager = alertManager
    }
    
    func loadData() {
        allFavoriteNews = storage.loadFavoriteNews()
        blockedNews = storage.loadBlockedNews()
        fetchNavigationBlock()
        loadNextPage()
    }
    
    func addNewsToFavourites(_ news: NewsItem) {
        guard !favoriteNews.contains(news) else { return }
        allFavoriteNews.append(news)
        storage.saveFavoriteNews(favoriteNews)
    }
    
    func removeNewsFromFavourites(_ news: NewsItem) {
        allFavoriteNews.removeAll { $0.id == news.id }
        storage.saveFavoriteNews(favoriteNews)
    }
    
    func blockNews(_ news: NewsItem) {
        guard !blockedNews.contains(news) else { return }
        blockedNews.append(news)
        storage.saveBlockedNews(blockedNews)
    }
    
    func unblockNews(_ news: NewsItem) {
        blockedNews.removeAll { $0.id == news.id }
        storage.saveBlockedNews(blockedNews)
    }
    
    func navigationButtonHandle(_ item: NavigationItem) {
        switch item.navigation {
        case .push:
            isPushNavigation = (true, item)
        case .modal:
            isShowModalNavigation = (true, item)
        case .fullScreen:
            isShowFullScreenNavigation = (true, item)
        }
    }
    
    func refresh() {
        isLoading = false
        currentPage = 1
        allNews = []
        allNavigationBlocks = []
        loadNextPage()
    }
    
    func loadNextPageIfNeeded(currentItem: NewsItem) {
        guard !isLoading else { return }
        
        if let lastNews = allNews.last, lastNews.id == currentItem.id {
            loadNextPage()
        }
    }
    
    func loadNextPage() {
        guard !isLoading else { return }
        isLoading = true
        
        service.fetchNews(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                isLoading = false
                if case let .failure(err) = completion {
                    alertManager.show(.init(title: "Something Went Wrong", message: err.localizedDescription, primaryAction: .default(Text("OK"))))
                }
            }, receiveValue: { [weak self] newNews in
                guard let self = self else { return }
                allNews.append(contentsOf: newNews)
                currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    private func fetchNavigationBlock() {
        service.fetchNavigation()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                isLoading = false
                if case let .failure(error) = completion {
                    alertManager.show(.init(title: "Something Went Wrong", message: error.localizedDescription, primaryAction: .default(Text("OK"))))
                }
            } receiveValue: { [weak self] newNavigation in
                guard let self = self else { return }
                allNavigationBlocks.append(contentsOf: newNavigation)
            }
            .store(in: &cancellables)
    }
}

extension NewsViewModel {
    enum ListPickerSegment: CaseIterable, Identifiable {
        case all
        case favorites
        case blocked
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .all:
                "All"
            case .favorites:
                "Favorites"
            case .blocked:
                "Blocked"
            }
        }
    }
}
