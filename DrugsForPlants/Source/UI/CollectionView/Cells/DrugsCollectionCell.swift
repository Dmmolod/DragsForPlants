//
//  DrugsCollectionCell.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

final class DrugsCollectionCell: UICollectionViewCell {
    
    private let drugsCellView = DrugsCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { nil }

    private func setupLayout() {
        contentView.addSubview(drugsCellView) {
            $0.edges.equalToSuperview()
        }
    }
    
    func config(with model: DrugsCellViewModel) {
        drugsCellView.config(with: model)
    }
  
}
