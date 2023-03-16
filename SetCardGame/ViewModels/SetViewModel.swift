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
        if model.deck.count == 0 && model.cardIndices(of: .matched).count != 0 {
            return false
        } else if model.deck.count == 0 {
            return true
        } else {
            return false
        }
    }

    func choose(_ card: Card) {
        model.choose(card)
    }

    func dealThreeMoreCards() {
        withAnimation {
            model.removeMatchedCards()

            model.dealThreeMoreCards()
        }
    }

    func newGame() {
        model = SetCardGame()
    }
}
