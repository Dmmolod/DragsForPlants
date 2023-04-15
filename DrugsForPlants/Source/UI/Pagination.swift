//
//  Pagination.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import UIKit

protocol PaginationEvent {
    func didScroll(_ scrollView: UIScrollView)
}

final class Pagination: PaginationEvent {
    
    var action: (() -> ())?
    var offset: Int
    var limit: Int
    var isEnabled: Bool
    
    init(
        offset: Int = 0,
        limit: Int = 20,
        isEnabled: Bool = true
    ) {
        self.offset = offset
        self.limit = limit
        self.isEnabled = isEnabled
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        guard isEnabled else { return }
        
        let insets = scrollView.contentInset
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let boundsHeight = scrollView.bounds.size.height
        let triggered = yOffset + boundsHeight - insets.bottom > contentHeight
        
        if triggered {
            isEnabled = false
            action?()
        }
    }
    
    func reset() {
        offset = 0
        isEnabled = false
    }
    
    func success() {
        offset += limit
        isEnabled = true
    }
}
