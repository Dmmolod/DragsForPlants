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
    
    var drugsList: Box<[AnyHashable]> = Box([1,2,3,4,5,6,7,8,9,10,11,12,13,141,55])
    
    private let drugsListApiClient: DrugsListApiClient
    
    private var currentOffset = 0
    
    init(drugsListApiClient: DrugsListApiClient) {
        self.drugsListApiClient = drugsListApiClient
    }
    
    func viewDidLoad() {
        fetchDrugs()
    }
    
    private func fetchDrugs() {
        drugsListApiClient.getDrugsList(
            count: 20,
            offset: currentOffset
        ) { [weak self] in
            
        }
    }
}
