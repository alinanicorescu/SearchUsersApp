//
//  UserAvatar.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import SwiftUI

struct UserAvatar: View {
    let urlString: String
    let letters: String?
    var size: CGFloat = 48.0
    
    init(urlString: String, letters: String?, size: CGFloat? = nil) {
        self.urlString = urlString
        self.letters = letters
        if let size = size {
            self.size = size
        }
    }
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .frame(width: size , height: size)
                    .clipShape(Circle())
            default:
                LettersInCircle(letters: letters, size: size)
            }
        }
    }
}

#Preview {
    UserAvatar(urlString: "https://randomuser.me/api/portraits/men/77.jpg", letters: "K")
}
