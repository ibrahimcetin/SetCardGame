//
//  SetViewModel.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 14.03.2023.
//

import SwiftUI

class SetViewModel: ObservableObject {
    @Published private var model = SetCardGame()

    var cardsOnScreen: [Card] {
        model.cardsOnScreen
    }

    var score: Int {
        model.score
    }

    var dealMoreCardsDisabled: Bool {
        model.deck.count == 0
    }

    func choose(_ card: Card) {
        model.choose(card)
    }

    func dealThreeMoreCards() {
        withAnimation {
            model.dealThreeMoreCards()

            model.removeMatchedCards()
        }
    }

    func newGame() {
        model = SetCardGame()
    }
}
