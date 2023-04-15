//
//  NavigationBar.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

protocol NavigationBarViewModel: AnyObject {
    var navBarTitle: Box<String> { get }
    func searchTextDidChange(_ text: String)
    func backButtonDidTap()
}

final class NavigationBar: UIView {
    
    //MARK: - Private Properties
    private lazy var titleLabel: UILabel = makeLabel()
    private lazy var backButton: UIButton = makeButton(image: .appArrowLeft)
    private lazy var searchButton: UIButton = makeButton(image: .appSearch)
    private lazy var searchField: UITextField = makeTextField()
    
    private var backAction: (() -> ())?
    private var searchTextDidChangeAction: ((String) -> ())?
    
    //MARK: - Initializers
    init() {
        super.init(frame: .zero)
        backgroundColor = .appGreenBar
        
        searchField.delegate = self
        setupTargets()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    //MARK: - Public Methods
    func configure(with model: NavigationBarViewModel) {
        titleLabel.text = model.navBarTitle.value
        
        model.navBarTitle.bind { [weak self] titleText in
            self?.titleLabel.text = titleText
        }
        
        backAction = { [weak model] in
            model?.backButtonDidTap()
        }
        
        searchTextDidChangeAction = { [weak model] newText in
            model?.searchTextDidChange(newText)
        }
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setSearchButton(isHidden: Bool, animated: Bool = true) {
        if isHidden { hideSearchField(animated: animated) }
        else { showSearchField(animated: animated) }
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
        animateSearchField()
    }
    
    @objc
    private func backDidTap() {
        backAction?()
    }
}

//MARK: - Text field delegate
extension NavigationBar: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        searchTextDidChangeAction?(newText)
        
        return true
    }
}

//MARK: - Private Layout
private extension NavigationBar {
    
    //MARK: - Search field layout methods
    func hideSearchField(animated: Bool = true) {
        searchField.resignFirstResponder()
        
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.searchField.snp.remakeConstraints {
                $0.bottom.equalToSuperview().inset(8)
                $0.trailing.equalTo(self.searchButton.snp.leading).offset(-20)
                $0.width.equalTo(0)
            }
            self.layoutIfNeeded()
        } completion: { _ in
            self.searchField.isHidden = true
        }
    }
    
    func showSearchField(animated: Bool = true) {
        searchField.isHidden = false
        searchField.becomeFirstResponder()
        
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            
            self.searchField.snp.remakeConstraints {
                $0.bottom.equalToSuperview().inset(8)
                $0.trailing.equalTo(self.searchButton.snp.leading).offset(-20)
                $0.leading.equalTo(self.backButton.snp.trailing).offset(20)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    func animateSearchField() {
        if searchField.isHidden {
            showSearchField()
        } else {
            hideSearchField()
        }
    }
    
    //MARK: - Layout
    func setupLayout() {
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
    
    //MARK: - Elements factory
    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.isHidden = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.leftView = UIView()
        textField.leftView?.frame.size.width = 20
        textField.leftViewMode = .always
        textField.textColor = .black
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        
        return textField
    }
    
    func makeButton(image: UIImage?) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFill
        
        return button
    }
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .appBarTitle
        label.textColor = .white
        
        return label
    }
}
