//
//  SetCardGameViewModel.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 14.03.2023.
//

import SwiftUI

class SetCardGameViewModel: ObservableObject {
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
        if model.deck.count == 0 && model.cardsWhich(.matched).count != 0 {
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

        // Remove matched cards and deal new cards
        let matchedCards = model.cardsWhich(.matched)

        if matchedCards.count > 0 {
            for (index, card) in matchedCards.enumerated() {
                withAnimation(model.deck.count > 0 ? .linear.delay(Double(index) * 0.1) : .default) {
                    let cardIndex = model.removeCard(card)

                    model.dealCard(insertAt: cardIndex)
                }
            }
        }

        // Unselect unmatched cards
        let unmatchedCards = model.cardsWhich(.unmatched)

        if unmatchedCards.count > 0 {
            for card in unmatchedCards {
                model.updateCardState(card, with: .unselected)
            }
        }

        // Check selected cards are matching or not
        let selectedCards = model.cardsWhich(.selected)

        if selectedCards.count == 3 {
            let isValidSet = model.isSet(selectedCards) || isCheatModeOn

            for card in selectedCards {
                if isValidSet {
                    model.updateCardState(card, with: .matched)
                } else {
                    model.updateCardState(card, with: .unmatched)
                }
            }

            model.updateScore(with: isValidSet ? 1 : -1)
        }
    }

    func dealCard(insertAt: Int? = nil) {
        model.dealCard(insertAt: insertAt)
    }

    func toggleCheatMode() {
        model.toggleCheatMode()
    }

}
