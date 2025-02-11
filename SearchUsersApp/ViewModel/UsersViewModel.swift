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
    
    private var fetchInfo: UsersFetchInfo
    
    var canLoadNextPage = true
    
    private var maxPages: Int = 3
    
    private var resultsPerPage: Int = 20
    
    let seed: String = "abc"
    
    init(maxPages: Int? = nil,
         resultsPerPage: Int? = nil,
         usersService: UsersServiceProtocol? = nil) {

        if let maxPages = maxPages {
            self.maxPages = maxPages
        }
        
        if let resultsPerPage = resultsPerPage {
            self.resultsPerPage = resultsPerPage
        }
        
        if let usersService = usersService {
            self.usersService = usersService
        }
        
        self.fetchInfo = UsersFetchInfo(seed: seed, results: 0, page: 0, version: "")
    }
    
    func tryFetchNextPage() {
        guard canLoadNextPage else { return }
        usersService.searchUsers(seed: seed, page: fetchInfo.page + 1, resultsPerPage: resultsPerPage)?
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error)
            canLoadNextPage = false
        }
    }
    
    private func onReceive(_ userSearchResult: UsersResult) {
        users += userSearchResult.results
        fetchInfo = userSearchResult.info
        print(users.last)
        canLoadNextPage = (fetchInfo.page < maxPages) && (
            fetchInfo.results == resultsPerPage)
    }
}
