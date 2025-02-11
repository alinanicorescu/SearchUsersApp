//
//  UsersListView.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import SwiftUI

struct UsersListView: View {
    let users: [User]
    var isLoading: Bool = false
    var onScrolledAtLastElement: () -> Void = {}
    
    var body: some View {
        List {
            ForEach(users) { user in
                UserRow(user: user).onAppear {
                    let index = self.users.count - 3
                    if index >= 0 && user == users[index] {
                        self.onScrolledAtLastElement()
                    }
                }
            }
        }
        .listStyle(.plain)
        
        if isLoading {
            ProgressView()
        }
    }
}

#Preview {
    let user1  = User(id: UUID(),
                      name:
                        UserName(title: "Mr", first: "FirstName1", last: "LastName1"),
                      picture:
                        UserPicture(large: "https://randomuser.me/api/portraits/men/77.jpg", medium: "https://randomuser.me/api/portraits/men/77.jpg", thumbnail: "https://randomuser.me/api/portraits/men/77.jpg"),
                      email: "firstName1.lastName1@gmail.com")
    let user2  = User(id: UUID(),
                      name:
                        UserName(title: "Mr", first: "FirstName2", last: "LastName2"),
                      picture:
                        UserPicture(large: "https://randomuser.me/api/portraits/men/77.jpg", medium: "https://randomuser.me/api/portraits/men/77.jpg", thumbnail: "https://randomuser.me/api/portraits/men/77.jpg"),
                      email: "firstName2.lastName2@gmail.com")
    let user3 = User(id: UUID(),
                     name:
                        UserName(title: "Mr", first: "FirstName3", last: "LastName3"),
                     picture:
                        UserPicture(large: "https://randomuser.me/api/portraits/men/77.jpg", medium: "https://randomuser.me/api/portraits/men/77.jpg", thumbnail: "https://randomuser.me/api/portraits/men/77.jpg"),
                     email: "firstName3.lastname3@gmail.com")
    UsersListView(users: [user1, user2, user3])
}
