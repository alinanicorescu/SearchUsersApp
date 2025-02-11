//
//  UserRow.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import SwiftUI

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack {
            UserAvatar(urlString: user.picture.medium, letters: user.initials)
            
            VStack (alignment: .leading) {
                Text(user.fullName)
                    .font(.body)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack {
                Text(user.time)
                    .font(.subheadline)
                Image(systemName: "star")
                
            }
            .font(.subheadline)
            .foregroundColor(.gray)
        }
    }
}

#Preview {
    let user  = User(id: UUID(),
                     name:
                        UserName(title: "King", first: "FirstName", last: "LastName"),
                     picture:
                        UserPicture(large: "https://randomuser.me/api/portraits/men/77.jpg", medium: "https://randomuser.me/api/portraits/men/77.jpg", thumbnail: "https://randomuser.me/api/portraits/men/77.jpg"),
                     email: "firstName.lastName@gmail.com")
    UserRow(user: user)
}
