//
//  CollectionView.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

final class CollectionView: UICollectionView {
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<UUID, AnyHashable>!
    private var sectionsStore: [Section] = []
    
    init(sections: [Section] = []) {
        super.init(frame: .zero, collectionViewLayout: .init())
        backgroundColor = .clear
        collectionViewLayout = createLayout()

        setupDataSource()
        setupCollection(with: sections)
        update(sections: sections)
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    func setup(sections: [Section]) {
        setupCollection(with: sections)
        update(sections: sections)
    }
    
    func update(sections: [Section]) {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, AnyHashable>()
        
        sections.forEach {
            snapshot.appendSections([$0.id])
            snapshot.appendItems($0.items.value)
            subscribeForItemsUpdate(items: $0.items)
        }

        sectionsStore = sections
        diffableDataSource.apply(snapshot)
    }
    
    //MARK: - Private Helpers
    private func section(at index: Int) -> Section? {
        guard index < sectionsStore.count else { return nil }
        return sectionsStore[index]
    }
    
    private func subscribeForItemsUpdate(items: Box<[AnyHashable]>) {
        items.bind { [weak self] _ in
            guard let self else { return }
            self.update(sections: self.sectionsStore)
        }
    }
}

//MARK: - Private Setup Collection
private extension CollectionView {
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            guard let section = section(at: sectionIndex) else { return nil }
            return section.layout(with: environment)
        }
    }
    
    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: self) { [unowned self] collectionView, indexPath, item in
            guard let section = section(at: indexPath.section) else { return nil }
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: section.cellType.reuseIdentifier,
                for: indexPath
            )
            section.configureCell(cell, with: item, at: indexPath, on: collectionView)
            
            return cell
        }
        
        diffableDataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            guard let section = section(at: indexPath.section) else { return nil }
            
            var reuseID: String?
            var configure: ((UICollectionReusableView) -> ())?
            
            if kind == UICollectionView.elementKindSectionHeader {
                reuseID = section.headerType?.reuseIdentifier
                configure = { section.configureHeader($0, at: indexPath, on: collectionView) }
            }
            if kind == UICollectionView.elementKindSectionFooter {
                reuseID = section.footerType?.reuseIdentifier
                configure = { section.configureFooter($0, at: indexPath, on: collectionView) }
            }
            guard let reuseID, let configure else { return nil }
            
            let supplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: reuseID,
                for: indexPath
            )
            configure(supplementary)
            
            return supplementary
        }
    }
    
    private func setupCollection(with sections: [Section]) {
        sections.forEach { section in
            registerSection(section)
        }
    }
    
    private func registerSection(_ section: Section) {
        let cellType = section.cellType
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
        
        if let headerType = section.headerType {
            register(
                headerType,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: headerType.reuseIdentifier
            )
        }
        
        if let footerType = section.footerType {
            register(
                footerType,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: footerType.reuseIdentifier
            )
        }
    }
}

extension CollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = section(at: indexPath.section),
              let cell = collectionView.cellForItem(at: indexPath),
              let item = diffableDataSource.itemIdentifier(for: indexPath)
        else { return }
        
        section.didSelect(cell, with: item, at: indexPath)
    }
}
