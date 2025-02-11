//
//  UsersListContainer.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import SwiftUI

struct UsersListContainer: View {
    @ObservedObject var viewModel: UsersViewModel
    
    var body: some View {
        Text("Users List Container")
    }
}

#Preview {
    UsersListContainer(viewModel: UsersViewModel())
}
