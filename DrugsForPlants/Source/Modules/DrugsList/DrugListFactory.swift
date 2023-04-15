//
//  DrugListFactory.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import UIKit

struct DrugListFactory {
    static func makeDrugListModule() -> UIViewController {
        let listApiClient = DrugsListApiClient()
        let viewModel = DrugsListViewModelImpl(drugsListApiClient: listApiClient)
        let viewController = DrugsListViewController(viewModel: viewModel)
        
        return viewController
    }
}
