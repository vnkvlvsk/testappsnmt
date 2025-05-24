//
//  NewsResponse.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

struct NewsResponse: Codable {
    let response: Response
    
    struct Response: Codable {
        let status: String
        let currentPage: Int
        let pageSize: Int
        let total: Int
        let pages: Int
        let results: [NewsItemDTO]
    }
}
