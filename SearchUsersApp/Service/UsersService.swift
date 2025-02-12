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
    
    func searchUsers(_ request: UsersRequest) -> AnyPublisher<UsersResult, Error>
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
    
    func searchUsers(_ request: UsersRequest) -> AnyPublisher<UsersResult, any Error>  {
        guard let url = createUrl(request) else {
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
    
    private func createUrl(_ request: UsersRequest) -> URL? {
        let components = URLComponents(string: urlString)
        guard var components = components else {
            return nil
        }
        components.queryItems =  [
            URLQueryItem(name: UrlParams.seed.rawValue, value: request.seed),
            URLQueryItem(name: UrlParams.page.rawValue, value: String(request.page)),
            URLQueryItem(name: UrlParams.results.rawValue, value: String(request.resultsPerPage))
        ]
        return components.url
    }
}
