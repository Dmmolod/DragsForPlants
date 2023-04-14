//
//  ConcreteSection.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

struct ConcreteSection<Cell, Item, Header, Footer>
where Cell: UICollectionViewCell, Item: Hashable, Header: UICollectionReusableView, Footer: UICollectionReusableView
{
    var id: UUID
    
    private let cellConfiguration: (Cell, Item, IndexPath, UICollectionView) -> ()
    private let layoutConfiguration: (NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
    private let headerConfiguration: ((Header, IndexPath, UICollectionView) -> ())?
    private let footerConfiguration: ((Footer, IndexPath, UICollectionView) -> ())?
    private let didSelectAction: ((Cell, Item, IndexPath) -> ())?
    
    let cellType: UICollectionViewCell.Type
    let headerType: UICollectionReusableView.Type?
    let footerType: UICollectionReusableView.Type?
    
    let items: Box<[AnyHashable]>
    
    init(
        id: UUID = UUID(),
        cellConfiguration: @escaping (Cell, Item, IndexPath, UICollectionView) -> Void,
        layoutConfiguration: @escaping (NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?,
        headerConfiguration: ((Header, IndexPath, UICollectionView) -> Void)? = nil,
        footerConfiguration: ((Footer, IndexPath, UICollectionView) -> Void)? = nil,
        didSelectAction: ((Cell, Item, IndexPath) -> Void)? = nil,
        cellType: Cell.Type,
        items: Box<[Item]>
    ) {
        self.id = id
        self.cellConfiguration = cellConfiguration
        self.layoutConfiguration = layoutConfiguration
        self.headerConfiguration = headerConfiguration
        self.footerConfiguration = footerConfiguration
        self.didSelectAction = didSelectAction
        self.cellType = cellType.self
        
        self.headerType = headerConfiguration != nil ? Header.self : nil
        self.footerType = footerConfiguration != nil ? Footer.self : nil
        self.items = Box(items.value)
        
        subscribe(items)
    }
    
    private func subscribe(_ items: Box<[Item]>) {
        let currentBox = self.items
        
        items.bind { updatedItems in
            currentBox.value = updatedItems
        }
    }
}

extension ConcreteSection: Section {
    
    func layout(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        return layoutConfiguration(environment)
    }
    
    func configureCell(_ cell: UICollectionViewCell, with item: AnyHashable, at indexPath: IndexPath, on collectionView: UICollectionView) {
        guard let cell = cell as? Cell, let item = item as? Item else { return }
        cellConfiguration(cell, item, indexPath, collectionView)
    }
    
    func configureHeader(_ header: UICollectionReusableView, at indexPath: IndexPath, on collectionView: UICollectionView) {
        guard let header = header as? Header else { return }
        headerConfiguration?(header, indexPath, collectionView)
    }
    
    func configureFooter(_ footer: UICollectionReusableView, at indexPath: IndexPath, on collectionView: UICollectionView) {
        guard let footer = footer as? Footer else { return }
        footerConfiguration?(footer, indexPath, collectionView)
    }
    
    func didSelect(_ cell: UICollectionViewCell, with item: AnyHashable, at indexPath: IndexPath) {
        guard let cell = cell as? Cell, let item = item as? Item else { return }
        didSelectAction?(cell, item, indexPath)
    }
}
