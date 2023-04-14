//
//  DrugsResponse.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

struct DrugsResponse: Hashable, Codable {
    let id: Int
    let name: String
    let image: String?
    let categories: [DrugsCategoriesResponse]
    let description: String
    let documentation: String
    let fields: [FieldsResponse]
}
