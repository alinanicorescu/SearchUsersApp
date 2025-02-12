//
//  UsersViewModel.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import Foundation
import Combine

protocol UsersViewModelDelegateProtocol {
    
    func onReceivedResults(results: UsersResult)
    
    func onReceivedResultsError(error: Error)
    
    func onFetchedResults()
    
    func onReceivedSeed(seed: String)
}

protocol UsersViewModelProtocol: ObservableObject {
    
    var usersService: UsersServiceProtocol? { get }
    
    func tryFetchNextPage()
}

final class UsersViewModel: UsersViewModelProtocol {
    
    var usersService: UsersServiceProtocol?
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published
    var users: [User] = []
    
    @Published
    var isLoading = false
    
    private var fetchInfo: UsersFetchInfo?
    
    private var canLoadNextPage = true
    
    private var maxPages: Int = 3
    
    private var resultsPerPage: Int = 20
    
    @Published
    var seed: String
    
    private var delegate: UsersViewModelDelegateProtocol?
    
    init(_ initialSeed: String = "",
         maxPages: Int? = nil,
         resultsPerPage: Int? = nil,
         usersService: UsersServiceProtocol? = nil,
         delegate: UsersViewModelDelegateProtocol? = nil) {
        
        self.seed = initialSeed
        
        if let maxPages = maxPages {
            self.maxPages = maxPages
        }
        
        if let resultsPerPage = resultsPerPage {
            self.resultsPerPage = resultsPerPage
        }
        
        if let usersService = usersService {
            self.usersService = usersService
        } else {
            self.usersService =  UsersService()
        }
        
        if let delegate = delegate {
            self.delegate = delegate
        }
        
        self.$seed.debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.onReceive(value)
            })
            .store(in: &subscriptions)
    }
    
    //Another option is to use swift concurrency with async await
    func tryFetchNextPage() {
        guard let usersService = usersService, canLoadNextPage else { return }
        willFetchNextPage()
        let usersRequest = UsersRequest(seed: seed, page: nextPage(), resultsPerPage: resultsPerPage)
        usersService.searchUsers(usersRequest)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func nextPage() -> Int {
        (fetchInfo?.page ?? 0) + 1
    }
    
    private func willFetchNextPage() {
        isLoading = true
        canLoadNextPage = false
        self.delegate?.onFetchedResults()
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        isLoading = false
        switch completion {
        case .finished:
            break
        case .failure(let error):
            canLoadNextPage = false
            self.delegate?.onReceivedResultsError(error: error)
        }
    }
    
    private func onReceive(_ userSearchResult: UsersResult) {
        isLoading = false
        users += userSearchResult.results
        self.fetchInfo = userSearchResult.info
        guard let fetchInfo =  self.fetchInfo else { return }
        
        canLoadNextPage = (fetchInfo.page < maxPages) && (
            fetchInfo.results == resultsPerPage)
        self.delegate?.onReceivedResults(results: userSearchResult)
    }
    
    private func onReceive(_ value: String) {
        users = []
        canLoadNextPage = true
        fetchInfo = nil
        tryFetchNextPage()
        self.delegate?.onReceivedSeed(seed: value)
    }
}
