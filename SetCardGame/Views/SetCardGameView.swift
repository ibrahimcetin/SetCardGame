//
//  SetCardGameView.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 15.03.2023.
//

import SwiftUI

struct SetCardGameView: View {
    @ObservedObject var game: SetCardGameViewModel

    @Namespace private var gameNamespace

    var body: some View {
        NavigationStack {
            VStack {
                gameBody

                HStack {
                    score

                    Spacer()

                    discardPile

                    deck
                        .animation(nil, value: game.deck)
                }
                .padding()
            }
            .navigationTitle("Set")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cheatModeButton
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    newGameButton
                }
            }
        }
    }

    var gameBody: some View {
        AspectVGrid(items: game.cardsOnScreen, aspectRatio: DC.aspectRatio) { card in
            CardView(card: card, aspectRatio: DC.aspectRatio)
                .rotation3DEffect(.degrees(card.state == .matched ? 360 : 0), axis: (0, 1, 0))
                .animation(.linear, value: card.state == .matched) // matched animation
                .offset(y: card.state == .unmatched ? -5 : 0)
                .animation(card.state == .unmatched ? .default.repeatCount(3).speed(1.25) : nil, value: card.state) // unmatched animation
                .cardify(isFaceUp: !game.deck.contains(card))
                .matchedGeometryEffect(id: card.id, in: gameNamespace)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                .padding(DC.padding)
                .onTapGesture {
                    game.choose(card)
                }
        }
    }

    var newGameButton: some View {
        Button("New Game") {
            withAnimation {
                game.newGame()
            }
        }
    }

    var cheatModeButton: some View {
        Button(game.isCheatModeOn ? "Turn off cheats" : "Turn on cheats") {
            game.toggleCheatMode()
        }
    }

    var score: some View {
        Text("Score: \(game.score)")
            .font(.title.bold())
    }

    var deck: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card: card)
                    .cardify(isFaceUp: !game.deck.contains(card))
                    .matchedGeometryEffect(id: card.id, in: gameNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .offset(offset(of: card, in: game.deck))
                    .zIndex(zIndex(of: card, in: game.deck))
            }
        }
        .frame(width: CardConstants.width, height: CardConstants.height)
        .padding(.horizontal)
        .onTapGesture {
            for index in 0..<3 {
                withAnimation(.linear.delay(Double(index) * DC.dealAnimationDelay)) {
                    game.dealCard()
                }
            }
        }
    }

    var discardPile: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card)
                    .cardify(isFaceUp: !game.deck.contains(card))
                    .matchedGeometryEffect(id: card.id, in: gameNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .offset(offset(of: card, in: game.discardPile))
                    .zIndex(zIndex(of: card, in: game.discardPile))
            }
        }
        .frame(width: CardConstants.width, height: CardConstants.height)
        .padding(.horizontal)
    }

    func zIndex(of card: Card, in cards: [Card]) -> Double {
        Double((cards.firstIndex(of: card) ?? 0))
    }

    func offset(of card: Card, in cards: [Card]) -> CGSize {
        let index = cards.firstIndex(of: card) ?? 0
        return CGSize(width: 0, height: -index)
    }
}

extension SetCardGameView {
    private typealias DC = DrawingConstants

    struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let padding: CGFloat = 5

        static let dealMoreCardsImage = "rectangle.portrait.on.rectangle.portrait.angled.fill"

        static let dealAnimationDelay: Double = 0.1
    }
}

extension SetCardGameView {
    struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let height: CGFloat = 90
        static let width = height * aspectRatio
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetCardGameView(game: SetCardGameViewModel())
    }
}
