//
//  Request.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import Foundation

struct Request {
    let method: String
    let path: String
    let query: [String: String]
}

extension Request {
    
    static func get(
        _ path: String,
        query: [String: String] = [:]
    ) -> Request{
        Request(
            method: "GET",
            path: path,
            query: query
        )
    }
    
}
