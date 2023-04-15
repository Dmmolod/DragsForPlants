//
//  SectionFactory.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

struct SectionFactory{
    static func drugsSection(
        cellConfiguration: @escaping (DrugsCollectionCell, Drug, IndexPath, UICollectionView) -> (),
        layoutConfiguration: @escaping (NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?,
        didSelectAction: ((DrugsCollectionCell, DrugsResponse, IndexPath) -> ())? = nil,
        items: Box<[Drug]>
    ) -> Section {
        ConcreteSection(
            cellConfiguration: cellConfiguration,
            layoutConfiguration: layoutConfiguration,
            cellType: DrugsCollectionCell.self,
            items: items
        )
    }
}
