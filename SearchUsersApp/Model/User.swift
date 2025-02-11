//
//  User.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import Foundation

struct UserName: Decodable {
    let title: String
    let first: String
    let last: String
}

struct UserPicture: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct User: Decodable, Identifiable, Equatable {
    
    var id: UUID
    let name: UserName
    let picture: UserPicture
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case name
        case picture
        case email
        
        enum LoginCodingKeys: String, CodingKey {
            case uuid
        }
    }
    
    init(id: UUID, name: UserName, picture: UserPicture, email: String) {
        self.id = id
        self.name = name
        self.picture = picture
        self.email = email
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        name = try rootContainer.decode(UserName.self, forKey: .name)
        picture = try rootContainer.decode(UserPicture.self, forKey: .picture)
        email = try rootContainer.decode(String.self, forKey: .email)
        let loginContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.LoginCodingKeys.self, forKey: .login)
        id = try loginContainer.decode(UUID.self, forKey: .uuid)
    }
    
    //i didn't find the property for the time
    var time: String {
        return "11:04"
    }
    
    var fullName: String {
        return name.first + " " + name.last
    }
    
    var initials: String? {
        guard let initialLetter = name.first.first else {
            return nil
        }
        return String(initialLetter)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
