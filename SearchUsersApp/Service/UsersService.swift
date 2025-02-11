//
//  UsersService.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import Foundation
import Combine

protocol ServiceBaseProtocol: AnyObject {
    
    var urlString: String { get }
}

protocol UsersServiceProtocol: ServiceBaseProtocol {
    
    func searchUsers( seed: String, page: Int, resultsPerPage: Int) -> AnyPublisher<UsersResult, Error>?
    
}

class UsersService: UsersServiceProtocol {
    
    var urlString: String = "https://randomuser.me/api/"
    
    init(urlString: String? = nil) {
        if let urlString = urlString {
            self.urlString = urlString
        }
    }
    
    func searchUsers(seed: String, page: Int, resultsPerPage: Int) -> AnyPublisher<UsersResult, Error>? {
        guard let url = URL(string: urlString + "?page=\(page)&results=\(resultsPerPage)&seed=\(seed)") else {
            return nil
        }
        print(url)
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(UsersResult.self, from: $0.data)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
