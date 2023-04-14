//
//  DrugsListApiClient.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

struct DrugsListApiClient {
    
    private let api: ApiClient
    
    init(api: ApiClient = ApiClient(host: "")) {
        self.api = api
    }
    
}

extension DrugsListApiClient {
    
    func getDrugsList(count: Int, offset: Int, completion: @escaping () -> ()) {
        
    }
}
