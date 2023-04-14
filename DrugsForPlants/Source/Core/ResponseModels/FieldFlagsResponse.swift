//
//  FieldFlagsResponse.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

struct FieldFlagsResponse: Hashable, Codable {
    let html: Int
    let noValue: Int
    let noName: Int
    let noImage: Int
    let noWrap: Int
    let noWrapName: Int
    
    enum CodingKeys: String, CodingKey {
        case html
        case noValue = "no_value"
        case noName = "no_name"
        case noImage = "no_image"
        case noWrap = "no_wrap"
        case noWrapName = "no_wrap_name"
    }
}

