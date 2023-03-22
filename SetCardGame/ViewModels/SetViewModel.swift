//
//  SetViewModel.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 14.03.2023.
//

import SwiftUI

class SetViewModel: ObservableObject {
    @Published private var model = SetCardGame()

    var deck: [Card] {
        model.deck
    }

    var cardsOnScreen: [Card] {
        model.cardsOnScreen
    }

    var discardPile: [Card] {
        model.discardPile
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

    var isCheatModeOn: Bool {
        model.isCheatModeOn
    }


    func newGame() {
        model = SetCardGame()
    }

    // MARK: Intents

    func choose(_ card: Card) {
        model.choose(card)

        // Remove selected cards and deal new cards
        if model.cardIndices(of: .matched).count > 0 {
            for (index, cardIndex) in model.cardIndices(of: .matched).enumerated() {
                withAnimation(.linear.delay(Double(index) * 0.1)) {
                    model.removeCard(at: cardIndex)

                    model.dealCard(insertAt: cardIndex)
                }

            }
        }

        // Unselect unmatched cards
        model.unselectUnmatchedCards()

        // Check selected cards are matching or not
        model.checkSelectedCards()
    }

    func dealCard(insertAt: Int? = nil) {
        model.dealCard(insertAt: insertAt)
    }

    func toggleCheatMode() {
        model.toggleCheatMode()
    }

}
