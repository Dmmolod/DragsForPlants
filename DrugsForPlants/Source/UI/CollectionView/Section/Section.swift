//
//  Section.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

protocol Section {
    var id: UUID { get }
    
    var cellType: UICollectionViewCell.Type { get }
    var headerType: UICollectionReusableView.Type? { get }
    var footerType: UICollectionReusableView.Type? { get }
    
    var items: Box<[AnyHashable]> { get }
    
    func layout(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
    func configureCell(_ cell: UICollectionViewCell, with item: AnyHashable, at indexPath: IndexPath, on collectionView: UICollectionView)
    func configureHeader(_ header: UICollectionReusableView, at indexPath: IndexPath, on collectionView: UICollectionView)
    func configureFooter(_ footer: UICollectionReusableView, at indexPath: IndexPath, on collectionView: UICollectionView)
    
    func didSelect(_ cell: UICollectionViewCell, with item: AnyHashable, at indexPath: IndexPath)
}

//MARK: Optional
extension Section {
    var headerType: UICollectionReusableView.Type? { nil }
    var footerType: UICollectionReusableView.Type? { nil }
    func configureHeader(_ header: UICollectionReusableView, at indexPath: IndexPath, on collectionView: UICollectionView) { }
    func configureFooter(_ footer: UICollectionReusableView, at indexPath: IndexPath, on collectionView: UICollectionView) { }
    func didSelect(_ cell: UICollectionViewCell, with item: AnyHashable, at indexPath: IndexPath) { }
}
