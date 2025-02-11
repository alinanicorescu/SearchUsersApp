//
//  UsersResult.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import Foundation

struct UsersFetchInfo: Decodable {
    var seed: String
    var results: Int
    var page: Int
    var version: String
}

struct UsersResult: Decodable {
    let results: [User]
    let info: UsersFetchInfo
}
