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
                isLoading: viewModel.isLoading,
                onScrolledAtLastElement: viewModel.tryFetchNextPage
            )
            .toolbarBackground(Color.yellow, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Users")
        }
        .searchable(text: $viewModel.seed, placement: .toolbar, prompt: "Search users...")
        .onAppear {
            UISearchBar.appearance().tintColor = .black
            viewModel.tryFetchNextPage()
        }
    }
}

#Preview {
    UsersListContainer(viewModel: UsersViewModel())
}
