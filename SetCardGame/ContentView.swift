//
//  ContentView.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 15.03.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: SetViewModel

    var body: some View {
        NavigationStack {
            VStack {
                AspectVGrid(items: game.cardsOnScreen, aspectRatio: DC.aspectRatio) { card in
                    CardView(card: card, aspectRatio: DC.aspectRatio)
                        .padding(DC.padding)
                        .onTapGesture {
                            game.choose(card)
                        }
                }

                HStack {
                    Text("Score: \(game.score)")
                        .font(.title.bold())

                    Spacer()

                    Button {
                        game.dealThreeMoreCards()
                    } label: {
                        Image(systemName: DC.dealMoreCardsImage)
                            .font(.title)
                    }
                    .disabled(game.dealMoreCardsDisabled)
                }
                .padding()
            }
            .navigationTitle("Set")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(game.isCheatModeOn ? "Turn off cheats" : "Turn on cheats") {
                        game.toggleCheatMode()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Game") {
                        game.newGame()
                    }
                }
            }
        }
    }
}

extension ContentView {
    private typealias DC = DrawingConstants

    struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let padding: CGFloat = 5

        static let dealMoreCardsImage = "rectangle.portrait.on.rectangle.portrait.angled.fill"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: SetViewModel())
    }
}
