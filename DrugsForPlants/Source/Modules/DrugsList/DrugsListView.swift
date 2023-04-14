//
//  DrugsListView.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

protocol DrugsListCollectionViewModel {
    var drugsList: Box<[AnyHashable]> { get }
}

final class DrugsListView: UIView {
    
    enum Constant {
        static let navBarHeight: CGFloat = 40
        static let collectionTopOffset: CGFloat = 24
    }
    
    private let navigationBar = NavigationBar()
    private let collectionView = CollectionView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func setupCollection(with model: DrugsListCollectionViewModel) {
        let drugsListSection = SectionFactory.drugsSection(
            cellConfiguration: { cell, item, _, _ in
                cell.backgroundColor = .purple
            },
            layoutConfiguration: { _ in
                CollectionViewLayoutFactory.makeHorizontalGridLayout()
            },
            items: model.drugsList
        )
        
        collectionView.setup(sections: [drugsListSection])
    }

    private func setupLayout() {
        collectionView.contentInset = .init(
            top: Constant.collectionTopOffset,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        addSubview(navigationBar) {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.snp.topMargin).offset(Constant.navBarHeight)
        }
        
        addSubview(collectionView) {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

