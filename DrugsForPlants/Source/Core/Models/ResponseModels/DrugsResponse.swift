//
//  DrugsResponse.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

struct DrugsResponse: Hashable, Codable {
    let name: String
    let image: String?
    let description: String
    let categories: DrugsCategoriesResponse
}
