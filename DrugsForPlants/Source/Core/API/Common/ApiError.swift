//
//  ApiError.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import Foundation

struct ApiError: LocalizedError, Error {
    let code: String?
    let message: String
    
    init(code: String? = nil, message:  String) {
        self.code = code
        self.message = message
    }
    
    init(_ error: Error) {
        self.init(code: nil, message: error.localizedDescription)
    }
    
    var errorDescription: String? {
        var codeText: String?
        if let code {
            codeText = "code: \(code). "
        }
        
        return "[API ERROR]: \(codeText ?? "")message: \(message)"
    }
    
}
