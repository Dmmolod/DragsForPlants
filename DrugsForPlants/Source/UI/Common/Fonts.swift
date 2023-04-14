//
//  Fonts.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import UIKit

extension UIFont {
    
    ///weight: 600, size: 17
    static let appBarTitle = sfProDisplaySemibold(size: 17)
}

extension UIFont {
    
    static func sfProDisplaySemibold(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Semibold", size: size)!
    }
    
}
