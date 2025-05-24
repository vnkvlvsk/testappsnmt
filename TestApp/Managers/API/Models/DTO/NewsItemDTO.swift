//
//  NewsItemDTO.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Foundation

struct NewsItemDTO: Codable {
    let id: String
    let type: String
    let sectionId: String
    let sectionName: String
    let webPublicationDate: String
    let webTitle: String
    let webUrl: String
    let apiUrl: String
    let isHosted: Bool
    let pillarId: String?
    let pillarName: String?
}

extension NewsItemDTO {
    func toDomainModel() -> NewsItem {
        NewsItem(
            id: id,
            type: type,
            sectionId: sectionId,
            sectionName: sectionName,
            webPublicationDate: webPublicationDate,
            webTitle: webTitle,
            webUrl: webUrl,
            apiUrl: apiUrl,
            isHosted: isHosted,
            pillarId: pillarId,
            pillarName: pillarName
        )
    }
}
