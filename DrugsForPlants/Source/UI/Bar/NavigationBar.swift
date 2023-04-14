//
//  NavigationBar.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

final class NavigationBar: UIView {
    //MARK: - Public Properties
    var backButtonDidTap: (() -> ())?
    var textFieldDidChangeText: ((String) -> ())?
    
    //MARK: - Private Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .appBarTitle
        label.textColor = .white
        
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.appArrowLeft, for: .normal)
        button.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(.appSearch, for: .normal)
        button.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.isHidden = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.leftView = UIView()
        textField.leftView?.frame.size.width = 20
        textField.leftViewMode = .always
        textField.textColor = .black
        
        return textField
    }()
    
    //MARK: - Initializers
    init(
        backAction: (() -> ())?,
        withSearch: Bool
    ) {
        super.init(frame: .zero)
        backgroundColor = .appGreenBar
        
        self.backButtonDidTap = backAction
        searchField.delegate = self
        setupTargets()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    //MARK: - Public Methods
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setSearchButton(isHidden: Bool) {
        searchButton.isHidden = isHidden
    }
    
    func setBackButton(isHidden: Bool) {
        backButton.isHidden = isHidden
    }
    
    //MARK: - Private Methods
    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backDidTap), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchDidTap), for: .touchUpInside)
    }
    
    @objc
    private func searchDidTap() {
        let needShow = searchField.isHidden
        if needShow {
            searchField.isHidden = false
            searchField.becomeFirstResponder()
        } else {
            searchField.resignFirstResponder()
        }
        
        UIView.animate(withDuration: 0.3) {
            
            self.searchField.snp.remakeConstraints {
                $0.bottom.equalToSuperview().inset(8)
                $0.trailing.equalTo(self.searchButton.snp.leading).offset(-20)
                if needShow {
                    $0.leading.equalTo(self.backButton.snp.trailing).offset(20)
                } else {
                    $0.width.equalTo(0)
                }
            }
            
            self.layoutIfNeeded()
        } completion: { _ in
            if needShow == false {
                self.searchField.isHidden = true
            }
        }
    }
    
    @objc
    private func backDidTap() {
        backButtonDidTap?()
    }
    
    private func setupLayout() {
        addSubview(backButton) {
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(24)
            $0.size.equalTo(24)
        }
        
        addSubview(searchButton) {
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        addSubview(titleLabel) {
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.trailing.equalTo(searchButton.snp.leading)
        }
        
        addSubview(searchField) {
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-20)
            $0.width.equalTo(0)
        }
    }
}

extension NavigationBar: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        textFieldDidChangeText?(newText)
        
        return true
    }
}
