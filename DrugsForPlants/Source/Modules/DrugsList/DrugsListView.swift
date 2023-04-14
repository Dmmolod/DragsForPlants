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
    
    var backButtonDidTap: (() -> ())?
    
    private lazy var navigationBar = NavigationBar(
        backAction: { [unowned self] in backButtonDidTap?() },
        withSearch: true
    )
    
    private let collectionView = CollectionView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        navigationBar.setTitle(text: "Болезни")
        setupLayout()
        
        navigationBar.textFieldDidChangeText = { [unowned self] text in
            print(text)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        ))
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

    @objc
    private func hideKeyboard() {
        endEditing(true)
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

