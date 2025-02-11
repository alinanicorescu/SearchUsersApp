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
    
    func searchUsers( seed: String, page: Int, resultsPerPage: Int) -> AnyPublisher<UsersResult, Error>
}

class UsersService: UsersServiceProtocol {
    
    var urlString: String = "https://randomuser.me/api/"
    
    enum UrlParams: String {
        case seed, page, results
    }
    
    init(urlString: String? = nil) {
        if let urlString = urlString {
            self.urlString = urlString
        }
    }
    
    func searchUsers(seed: String, page: Int, resultsPerPage: Int) -> AnyPublisher<UsersResult, any Error>  {
        var components = URLComponents(string: urlString)
        guard var components = components else {
            return Empty().setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        components.queryItems =  [
            URLQueryItem(name: UrlParams.seed.rawValue, value: seed),
            URLQueryItem(name: UrlParams.page.rawValue, value: String(page)),
            URLQueryItem(name: UrlParams.results.rawValue, value: String(resultsPerPage))
        ]
        
        guard let url = components.url else {
            return Empty().setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap {
                element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }.decode(type: UsersResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
