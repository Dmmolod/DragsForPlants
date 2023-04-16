//
//  Debouncer.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import Foundation

final class Debouncer {
   
    private(set) var currentItemID: String?
    
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    
    init(delay: TimeInterval = 0.3) {
        self.delay = delay
    }
    
    func debounce(action: @escaping (String) -> ()) {
        workItem?.cancel()
        
        let id = UUID().uuidString
        currentItemID = id
        
        workItem = DispatchWorkItem {
            action(id)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let workItem = self?.workItem, workItem.isCancelled == false else { return }
            
            workItem.perform()
        }
    }
    
    func cancel() {
        currentItemID = nil
        workItem?.cancel()
        workItem = nil
    }
    
    deinit {
        workItem?.cancel()
    }
}
