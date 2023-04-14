//
//  FieldsResponse.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

struct FieldsResponse: Hashable, Codable {
    let type: FieldsTypeResponse
    let text: String
    let name: String
    let value: String
    let image: String
    let flags: FieldFlagsResponse
    let show: Int
    let group: Int
}

enum FieldsTypeResponse: String, Codable {
    case text
    case image
    case gallery
    case textBlock
    case list
    case button
    
    enum CodingKeys: String, CodingKey {
        case textBlock = "text_block"
    }
}
