//
//  UIVIew+Extension.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit
import SnapKit

extension UIView {
    
    func addSubview(_ view: UIView, layout: (ConstraintMaker) -> ()) {
        addSubview(view)
        view.snp.makeConstraints(layout)
    }
    
}
