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
    
    func tryFetchNextPage() {
        
    }
    
}
