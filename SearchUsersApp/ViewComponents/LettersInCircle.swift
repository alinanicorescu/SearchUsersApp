//
//  LettersInCircle.swift
//  SearchUsersApp
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import SwiftUI

struct LettersInCircle: View {
    let letters: String?
    
    var size: CGFloat = 48.0
    var font: Font = .custom("HelveticaNeue-Medium", size: 11.0)
    
    init(letters: String?, size: CGFloat? = nil, font: Font? = nil) {
        self.letters = letters
        if let size = size {
            self.size = size
        }
        if  let font = font {
            self.font = font
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.yellow)
                .frame(width: size, height: size)
            
            if let letters = letters {
                Text(letters)
                    .foregroundColor(.black)
                    .font(font)
            }
        }
    }
}

#Preview {
    LettersInCircle(letters: "K")
}
