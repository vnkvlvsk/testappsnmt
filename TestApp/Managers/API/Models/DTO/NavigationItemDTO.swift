//
//  NavigationItemDTO.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import Foundation

struct NavigationItemDTO: Codable {
    let id: Int
    let titleSymbol: String?
    let title: String
    let subtitle: String?
    let buttonTitle: String
    let buttonSymbol: String?
    let navigation: String

    enum CodingKeys: String, CodingKey {
        case id
        case titleSymbol = "title_symbol"
        case title
        case subtitle
        case buttonTitle = "button_title"
        case buttonSymbol = "button_symbol"
        case navigation
    }
}

extension NavigationItemDTO {
    func toDomainModel() -> NavigationItem {
        NavigationItem(
            id: String(id),
            title: title,
            titleSymbol: titleSymbol,
            subtitle: subtitle,
            buttonTitle: buttonTitle,
            buttonSymbol: buttonSymbol,
            navigation: NavigationItem.NavigationType(rawValue: navigation) ?? .modal
        )
    }
}

