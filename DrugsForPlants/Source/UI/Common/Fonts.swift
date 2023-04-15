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
    
    ///weight: 600, size: 13
    static let appTitle = sfProDisplaySemibold(size: 13)
    
    ///weight: 500, size: 12
    static let appDescription = sfProDisplayMedium(size: 12)
}

extension UIFont {
    
    static func sfProDisplaySemibold(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Semibold", size: size)!
    }
    
    static func sfProDisplayMedium(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Medium", size: size)!
    }
    
}
