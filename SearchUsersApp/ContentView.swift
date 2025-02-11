//
//  ContentView.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import SwiftUI

struct ContentView: View {
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor.yellow
    }
    var body: some View {
        UsersListContainer(viewModel: UsersViewModel())
    }
}

#Preview {
    ContentView()
}
