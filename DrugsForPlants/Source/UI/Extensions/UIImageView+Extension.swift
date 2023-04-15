//
//  UIImageView+Extension.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with imageString: String, defaultDownsamplingSize: CGSize = CGSize(width: 300, height: 300)) {
        guard let url = URLComponents(string: imageString)?.url else { return }
        let size = (bounds.size == .zero) ? defaultDownsamplingSize : bounds.size
        kfSetImage(url, downsamplingSize: size)
    }
    
    private func kfSetImage(_ url: URL, downsamplingSize: CGSize) {
        kf.setImage(
            with: url,
            options: [
                .cacheOriginalImage,
                .processor(DownsamplingImageProcessor(size: downsamplingSize)),
                .scaleFactor(UIScreen.main.scale)
            ]
        )
    }
}

