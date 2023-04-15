//
//  Debouncer.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import Foundation

final class Debouncer {
    
    private(set) var isCancelled: Bool = false
    
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    
    init(delay: TimeInterval = 0.3) {
        self.delay = delay
    }
    
    func debounce(action: @escaping () -> ()) {
        workItem?.cancel()
        
        let item = DispatchWorkItem(block: action)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard !item.isCancelled else { return }
            
            item.perform()
            
            self?.workItem = nil
        }
        
        workItem = item
        isCancelled = false
    }
    
    func cancel() {
        workItem?.cancel()
        workItem = nil
        isCancelled = true
    }
    
    deinit {
        workItem?.cancel()
    }
}
