//
//  DrugsListViewModel.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

protocol DrugsListViewModelBaseProtocol {
    func viewDidLoad()
}

typealias DrugsListViewModel = DrugsListViewModelBaseProtocol & DrugsListCollectionViewModel

final class DrugsListViewModelImpl: DrugsListViewModel {
    
    var drugsList: Box<[Drug]> = Box([])
    
    private let drugsListApiClient: DrugsListApiClient
    
    private var currentOffset = 0
    
    init(drugsListApiClient: DrugsListApiClient) {
        self.drugsListApiClient = drugsListApiClient
    }
    
    func viewDidLoad() {
        fetchDrugs()
    }
    
    func search(_ text: String) {
        drugsListApiClient.getDrugsList(
            search: text,
            count: 20,
            offset: 0
        ) { [weak self] result in
            result.onSuccess { [weak self] response in
                print(response)
            }.onFailure { error in
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchDrugs() {
        drugsListApiClient.getDrugsList(
            count: 20,
            offset: currentOffset
        ) { [weak self] result in
            result.onSuccess { response in
                let drugs: [Drug] = response.map { .make(with: $0) }
                self?.drugsList.value.append(contentsOf: drugs)
            }.onFailure { error in
                print(error.localizedDescription)
            }
        }
    }
}
