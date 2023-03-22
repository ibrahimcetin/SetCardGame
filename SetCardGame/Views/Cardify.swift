//
//  Cardify.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 20.03.2023.
//

import SwiftUI


extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

struct Cardify: ViewModifier {
    var isFaceUp = false

    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 10)

            if isFaceUp {
                shape
                    .fill(colorScheme == .dark ? .black : .white)
            } else {
                shape
            }

            shape
                .strokeBorder(lineWidth: 3)
                .foregroundColor(colorScheme == .dark ? .black : .white)


            content.opacity(isFaceUp ? 1 : 0)
        }
    }
}
