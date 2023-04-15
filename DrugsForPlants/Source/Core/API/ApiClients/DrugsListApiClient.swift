//
//  DrugsListApiClient.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

struct DrugsListApiClient {
    
    private let api: ApiClient
    
    init(api: ApiClient = ApiClient()) {
        self.api = api
    }
    
}

extension DrugsListApiClient {
    
    func getDrugsList(
        search: String? = nil,
        count: Int?,
        offset: Int?,
        responseCompletion: @escaping (Result<[DrugsResponse], ApiError>) -> ()
    ) {
        let request = Request.get(
            "/api/ppp/index",
            query: makeQuery(search: search, offset: offset, limit: count)
        )
        api.request(request, response: responseCompletion)
    }
}

private extension DrugsListApiClient {
    func makeQuery(search: String?, offset: Int?, limit: Int?) -> [String: String] {
        var query: [String: String] = [:]
        
        if let search { query["search"] = search }
        if let offset { query["offset"] = "\(offset)" }
        if let limit { query["limit"] = "\(limit)" }
        
        return query
    }
}
