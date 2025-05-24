//
//  FetchAPIService.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Foundation
import Combine

final class FetchAPIService: FetchAPIServiceProtocol {

    private let baseURL = URL(string: "https://us-central1-server-side-functions.cloudfunctions.net")
    private let decoder = JSONDecoder()

    func fetchNews(page: Int) -> AnyPublisher<[NewsItem], Error> {
        guard let url = baseURL?.appendingPathComponent("/guardian"),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        components.queryItems = [URLQueryItem(name: "page", value: "\(page)")]

        guard let finalURL = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue("ivan-kavaleuski", forHTTPHeaderField: "Authorization")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: NewsResponse.self, decoder: decoder)
            .map { $0.response.results.map { $0.toDomainModel() } }
            .eraseToAnyPublisher()
    }

    func fetchNavigation() -> AnyPublisher<[NavigationItem], Error> {
        guard let url = baseURL?.appendingPathComponent("/navigation") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("ivan-kavaleuski", forHTTPHeaderField: "Authorization")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: NavigationResponse.self, decoder: decoder)
            .map { $0.results.map { $0.toDomainModel() } }
            .eraseToAnyPublisher()
    }
}

