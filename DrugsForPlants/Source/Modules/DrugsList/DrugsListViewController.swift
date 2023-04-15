//
//  ViewController.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

class DrugsListViewController: UIViewController {
    
    private let viewModel: DrugsListViewModel
    
    private let drugsView = DrugsListView()
    
    init(viewModel: DrugsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        drugsView.configure(with: viewModel)
    }
    
    required init?(coder: NSCoder) { nil }

    override func loadView() {
        view = drugsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

}
