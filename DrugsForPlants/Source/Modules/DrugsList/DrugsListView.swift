//
//  DrugsListView.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

protocol DrugsListCollectionViewModel {
    var paginationEvent: PaginationEvent { get }
    var drugsList: Box<[Drug]> { get }
}

final class DrugsListView: UIView {
    
    private enum Constant {
        static let navBarHeight: CGFloat = 40
        static let collectionTopOffset: CGFloat = 24
    }
    
    //MARK: - Private Properties
    private lazy var navigationBar = NavigationBar()
    private let collectionView = CollectionView()
    
    //MARK: - Initializers
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        navigationBar.setTitle(text: "Болезни")
        setupLayout()
        
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        ))
    }
    
    required init?(coder: NSCoder) { nil }
    
    //MARK: - API
    func configure(with model: DrugsListViewModel) {
        setupCollection(with: model)
        navigationBar.configure(with: model)
    }
    
    //MARK: - Private Methods
    private func setupCollection(with model: DrugsListCollectionViewModel) {
        let drugsListSection = SectionFactory.drugsSection(
            cellConfiguration: { cell, item, _, _ in
                let model = DrugsAdapter.toDrugsCellViewModel(item)
                cell.config(with: model)
            },
            layoutConfiguration: { _ in
                CollectionViewLayoutFactory.makeHorizontalGridLayout()
            },
            items: model.drugsList
        )
        
        collectionView.setup(
            sections: [drugsListSection],
            pagination: model.paginationEvent
        )
    }

    @objc
    private func hideKeyboard() {
        navigationBar.setSearchButton(isHidden: true)
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

