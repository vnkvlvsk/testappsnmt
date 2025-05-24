//
//  NewsItem.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Foundation

struct NewsItem: Codable, Identifiable, Equatable {
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
