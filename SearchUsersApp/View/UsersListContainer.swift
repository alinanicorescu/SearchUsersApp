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
        NavigationStack {
            UsersListView(
                users: viewModel.users,
                isLoading: viewModel.canLoadNextPage,
                onScrolledAtLastElement: viewModel.tryFetchNextPage
            )
            .onAppear(perform: viewModel.tryFetchNextPage)
        }
    }
}

#Preview {
    UsersListContainer(viewModel: UsersViewModel())
}
