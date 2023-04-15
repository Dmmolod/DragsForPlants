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
    let description: String
}

extension Drug {
    static func make(with model: DrugsResponse) -> Drug {
        Drug(
            name: model.name,
            image: model.image,
            description: model.description
        )
    }
}
