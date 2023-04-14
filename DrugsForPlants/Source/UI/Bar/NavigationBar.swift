//
//  NavigationBar.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

final class NavigationBar: UIView {
    
    private lazy var backButton = UIButton()
    private lazy var searchButton = UIButton()
    private lazy var searchField = UITextField()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .appGreenBar
    }
    
    required init?(coder: NSCoder) { nil }

}
