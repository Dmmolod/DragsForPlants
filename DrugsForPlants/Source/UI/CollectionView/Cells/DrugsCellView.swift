//
//  DrugsCellView.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 15.04.2023.
//

import UIKit

struct DrugsCellViewModel {
    var image: String
    var titleText: String
    var descriptionText: String
}

final class DrugsCellView: UIView {
    
    private enum Constant {
        static let radius: CGFloat = 8
        static let imageHeight: CGFloat = 82
        static let insets: CGFloat = 12
    }
    
    private lazy var imageView = makeImageView()
    private lazy var titleLabel = makeLabel(font: .appTitle, textColor: .black)
    private lazy var descriptionLabel = makeLabel(font: .appDescription, textColor: .appLightGray)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        titleLabel.text = "Test test test test test test test test test test test test test test test test test"
        descriptionLabel.text = "Test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test"
        setAppereance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { nil }

    func config(with model: DrugsCellViewModel) {
        imageView.setImage(with: model.image)
        titleLabel.text = model.titleText
        descriptionLabel.text = model.descriptionText
    }
}



//MARK: - Private layout
private extension DrugsCellView {
    
    func setupLayout() {
        
        let vTextStack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel
        ])
        vTextStack.axis = .vertical
        vTextStack.spacing = 6
        vTextStack.alignment = .leading

        let vMainStack = UIStackView(arrangedSubviews: [
            imageView,
            vTextStack
        ])

        vMainStack.axis = .vertical
        vMainStack.spacing = 12

        addSubview(vMainStack) {
            $0.top.leading.trailing.equalToSuperview().inset(Constant.insets)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constant.insets)
        }
    }
    
    func setAppereance() {
        layer.cornerRadius = Constant.radius
        
        layer.shadowColor = UIColor.appShadowGrey.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
    }
    
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constant.radius
        imageView.backgroundColor = .red
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(Constant.imageHeight)
        }
        
        return imageView
    }
    
    func makeLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = font
        label.textColor = textColor
        
        return label
    }
    
}
