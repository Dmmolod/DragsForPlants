//
//  Result.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import Foundation

extension Result {
    
    @discardableResult
    func onSuccess(_ closure: (Success) -> ()) -> Self {
        if case let .success(success) = self {
            closure(success)
        }
        return self
    }
    
    @discardableResult
    func onFailure(_ closure: (Failure) -> ()) -> Self {
        if case let .failure(failure) = self {
            closure(failure)
        }
        return self
    }
}
