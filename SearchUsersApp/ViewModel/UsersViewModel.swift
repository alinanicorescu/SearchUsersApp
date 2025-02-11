//
//  UsersViewModel.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import Foundation
import Combine

protocol UsersViewModelProtocol: ObservableObject {
    
    var usersService: UsersServiceProtocol { get }
    
    func tryFetchNextPage()
}

class UsersViewModel: UsersViewModelProtocol {
    
    var usersService: any UsersServiceProtocol = UsersService()
    
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
    
    init(_ initialSeed: String = "",
         maxPages: Int? = nil,
         resultsPerPage: Int? = nil,
         usersService: UsersServiceProtocol? = nil) {
        
        self.seed = initialSeed
        
        if let maxPages = maxPages {
            self.maxPages = maxPages
        }
        
        if let resultsPerPage = resultsPerPage {
            self.resultsPerPage = resultsPerPage
        }
        
        if let usersService = usersService {
            self.usersService = usersService
        }
        
        self.$seed.debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.onReceive(value)
            })
            .store(in: &subscriptions)
    }
    
    func tryFetchNextPage() {
        guard canLoadNextPage else { return }
        isLoading = true
        let fetchInfo = fetchInfo ?? UsersFetchInfo(seed: seed, results: self.resultsPerPage, page: 0, version: "")
        usersService.searchUsers(seed: seed , page: fetchInfo.page + 1, resultsPerPage: resultsPerPage)?
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        isLoading = false
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error)
            canLoadNextPage = false
        }
    }
    
    private func onReceive(_ userSearchResult: UsersResult) {
        isLoading = false
        users += userSearchResult.results
        fetchInfo = userSearchResult.info
        print(users.last)
        guard let fetchInfo = self.fetchInfo else {
            canLoadNextPage = false
            return
        }
        canLoadNextPage = (fetchInfo.page < maxPages) && (
            fetchInfo.results == resultsPerPage)
    }
    
    private func onReceive(_ value: String) {
        users = []
        canLoadNextPage = true
        fetchInfo = nil
        tryFetchNextPage()
    }
}
