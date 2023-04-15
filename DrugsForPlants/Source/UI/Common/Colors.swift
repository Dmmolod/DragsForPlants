//
//  Colors.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

extension UIColor {
    
    ///hex: #6FB54B
    static let appGreenBar = UIColor(r: 111, g: 181, b: 75, a: 1)
    
    ///hex: #484C4C26 15%
    static let appShadowGrey = UIColor(r: 72, g: 76, b: 76, a: 0.15)
    
    ///hex: #AEB0B6
    static let appLightGray = UIColor(r: 174, g: 176, b: 182, a: 1)
    
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
