//
//  ContentView.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        UsersListContainer(viewModel: UsersViewModel())
    }
}

#Preview {
    ContentView()
}
