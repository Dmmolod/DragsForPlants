//
//  DrugsAdapter.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import Foundation

struct DrugsAdapter {
    
    static func toDrugsCellViewModel(_ model: DrugsResponse) -> DrugsCellViewModel {
        DrugsCellViewModel(
            image: model.image ?? "",
            titleText: model.name,
            descriptionText: model.description
        )
    }
}
