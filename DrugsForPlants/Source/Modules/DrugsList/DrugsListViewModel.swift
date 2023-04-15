//
//  DrugsListViewModel.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import Foundation

protocol DrugsListViewModelBaseProtocol {
    func viewDidLoad()
}

typealias DrugsListViewModel = DrugsListViewModelBaseProtocol
& DrugsListCollectionViewModel
& NavigationBarViewModel

final class DrugsListViewModelImpl: DrugsListViewModel {
    
    private enum RequestType {
        case list
        case search
    }
    
    //MARK: - Public Properties
    var drugsList: Box<[Drug]> = Box([])
    var navBarTitle: Box<String> = Box("Препараты")
    let pagination = Pagination(isEnabled: false)
    
    //MARK: - Private Properties
    private let drugsListApiClient: DrugsListApiClient
    private let debouncer = Debouncer()
    
    private var responseListStore: [Drug] = []
    private var responseListLastOffset: Int = 0
    private var lastSearchText: String = ""
    
    private var requestType: RequestType = .list
    
    //MARK: - Initializer
    init(drugsListApiClient: DrugsListApiClient) {
        self.drugsListApiClient = drugsListApiClient
        
        pagination.action = { [weak self] in
            guard let self else { return }
            
            switch self.requestType {
            case .list: self.fetchDrugs()
            case .search: self.searchDrugs()
            }
        }
    }
    
    //MARK: - Public Methods
    func viewDidLoad() {
        fetchDrugs()
    }
    
    func searchTextDidChange(_ text: String) {
        debouncer.cancel()
        pagination.reset()
        
        if text.isEmpty {
            changeRequestType(.list)
            navBarTitle.value = "Препараты"
            return
        }
        
        navBarTitle.value = text
        lastSearchText = text
        changeRequestType(.search)
        
        debouncer.debounce { [weak self] in
            self?.drugsList.value = []
            self?.searchDrugs(text)
        }
    }
    
    func backButtonDidTap() {
        print("Need back")
    }
    
    //MARK: - Private Methods
    private func searchDrugs(_ text: String? = nil) {
        let searchText = text ?? lastSearchText
        
        drugsListApiClient.getDrugsList(
            search: searchText,
            count: pagination.limit,
            offset: pagination.offset
        ) { [weak self] result in
            result.onSuccess { [weak self] response in
                if !response.isEmpty && self?.debouncer.isCancelled == false {
                    self?.pagination.success()
                    self?.drugsResponseDidGet(response)
                }
            }.onFailure { error in
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchDrugs() {
        drugsListApiClient.getDrugsList(
            count: pagination.limit,
            offset: pagination.offset
        ) { [weak self] result in
            result.onSuccess { response in
                if !response.isEmpty {
                    self?.drugsResponseDidGet(response)
                    self?.pagination.success()
                    self?.updateResponseListInfo()
                }
            }.onFailure { error in
                print(error.localizedDescription)
            }
        }
    }
    
    private func drugsResponseDidGet(_ response: [DrugsResponse]) {
        let drugs: [Drug] = response.map { .make(with: $0) }
        self.drugsList.value.append(contentsOf: drugs)
    }
    
    private func updateResponseListInfo() {
        responseListStore = drugsList.value
        responseListLastOffset = pagination.offset
    }
    
    private func changeRequestType(_ newType: RequestType) {
        guard newType != requestType else { return }
        requestType = newType
        
        if newType == .list {
            drugsList.value = []
            drugsList.value = responseListStore
            
            pagination.offset = responseListLastOffset
            pagination.isEnabled = true
        }
    }
}

extension DrugsListViewModelImpl {
    var paginationEvent: PaginationEvent {
        return pagination
    }
}
