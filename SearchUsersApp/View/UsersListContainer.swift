//
//  UsersListContainer.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import SwiftUI

struct UsersListContainer: View {
    @ObservedObject var viewModel: UsersViewModel
    
    private let navTitle = "Users"
    private let searchPlaceholder = "Search user"
    
    var body: some View {
        NavigationStack {
            UsersListView(
                users: viewModel.users,
                isLoading: viewModel.isLoading,
                onScrolledAtLastElement: viewModel.tryFetchNextPage
            )
            .toolbarBackground(.yellow, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(navTitle)
        }
        .searchable(text: $viewModel.seed, placement: .toolbar, prompt: searchPlaceholder)
        .onAppear {
            viewModel.tryFetchNextPage()
        }
    }
}

#Preview {
    //UsersListContainer(viewModel: UsersViewModel())
}
