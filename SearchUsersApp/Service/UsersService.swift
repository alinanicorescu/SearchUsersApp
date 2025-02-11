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
    var urlString: String = ""
    
    func searchUsers(seed: String, page: Int, resultsPerPage: Int) -> AnyPublisher<UsersResult, any Error>? {
        return .none
    }
}
