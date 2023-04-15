//
//  Drug.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import Foundation

struct Drug: Hashable {
    let name: String
    let image: String?
    let categoryImage: String
    let description: String
}

extension Drug {
    static func make(with model: DrugsResponse) -> Drug {
        let baseImageUrl = "http://shans.d2.i-partner.ru"
        
        return Drug(
            name: model.name,
            image: baseImageUrl + (model.image ?? ""),
            categoryImage: baseImageUrl + model.categories.image,
            description: model.description
        )
    }
}
