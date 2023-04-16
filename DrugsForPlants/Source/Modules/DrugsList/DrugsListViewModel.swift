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
        
        debouncer.debounce { [weak self] itemID in
            self?.drugsList.value = []
            self?.searchDrugs(text, itemID: itemID)
        }
    }
    
    func backButtonDidTap() {
        print("Need back")
    }
    
    //MARK: - Private work with API
    private func searchDrugs(_ text: String? = nil, itemID: String? = nil) {
        let searchText = text ?? lastSearchText
        
        drugsListApiClient.getDrugsList(
            search: searchText,
            count: pagination.limit,
            offset: pagination.offset
        ) { [weak self] result in
            result.onSuccess { [weak self] response in
                guard !response.isEmpty else { return }
                guard itemID == nil || itemID == self?.debouncer.currentItemID else { return }
                
                self?.pagination.success()
                self?.drugsResponseDidGet(response)
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
    
    //MARK: - Work with response
    private func drugsResponseDidGet(_ response: [DrugsResponse]) {
        var drugs: [Drug] = response.map { .make(with: $0) }
        removeDuplicates(&drugs)
        
        self.drugsList.value.append(contentsOf: drugs)
    }
    
    private func removeDuplicates(_ newDrugs: inout [Drug]) {
        var exist: [String: String] = Dictionary(uniqueKeysWithValues: drugsList.value.map { ($0.name, "exist") })
        
        newDrugs = newDrugs.compactMap {
            if exist[$0.name] != nil { return nil }
            return $0
        }
    }
    
    private func updateResponseListInfo() {
        responseListStore = drugsList.value
        responseListLastOffset = pagination.offset
    }
    
    //MARK: - Work with requset type
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

//MARK: - DrugsListCollectionViewModel Property
extension DrugsListViewModelImpl {
    
    var paginationEvent: PaginationEventHadler {
        return pagination
    }
    
}
