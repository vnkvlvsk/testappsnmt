//
//  FetchAPIServiceProtocol.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Combine

protocol FetchAPIServiceProtocol {
    func fetchNews(page: Int) -> AnyPublisher<[NewsItem], Error>
    func fetchNavigation() -> AnyPublisher<[NavigationItem], Error>
}
