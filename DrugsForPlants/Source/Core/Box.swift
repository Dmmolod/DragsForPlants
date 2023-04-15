//
//  Box.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

final class Box<T: Hashable>: Hashable {
    
    private var callBack: ((T) -> ())?
    
    var value: T {
        didSet { callBack?(value) }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ callBack: @escaping (T) -> ()) {
        self.callBack = callBack
    }
    
    func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
    
    static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
        lhs.value == rhs.value
    }
}
