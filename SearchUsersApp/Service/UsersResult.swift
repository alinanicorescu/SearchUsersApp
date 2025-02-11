//
//  UsersResult.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import Foundation

struct UsersFetchInfo: Decodable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

struct UsersResult: Decodable {
    let results: [User]
    let info: UsersFetchInfo
}
