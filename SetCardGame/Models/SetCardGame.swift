//
//  SetCardGame.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 14.03.2023.
//

import Foundation

struct SetCardGame {
    private(set) var deck: [Card] = []
    private(set) var cardsOnScreen: [Card] = []
    private(set) var discardPile: [Card] = [] {
        didSet {
            discardPile = discardPile.map {
                var card = $0
                card.state = .unselected
                return card
            }
        }
    }

    private(set) var score = 0

    private(set) var isCheatModeOn = false

    init() {
        var id = 1
        for color in Card.Color.allCases {
            for number in Card.Number.allCases {
                for shading in Card.Shading.allCases {
                    for shape in Card.Shape.allCases {
                        deck.append(Card(color: color, number: number, shading: shading, shape: shape, id: id))
                        id += 1
                    }
                }
            }
        }

        deck.shuffle()

        cardsOnScreen.append(contentsOf: deck[..<12])
        deck.removeSubrange(..<12)
    }

    /// Returns the card indices in `cardsOnScreen` that have the given `state`.
    func cardIndices(of state: Card.State) -> [Int] {
        cardsOnScreen
            .filter { $0.state == state }
            .map { cardsOnScreen.firstIndex(of: $0)! }
    }

    /// Toggles given `card`'s state as selected or unselected.
    mutating func choose(_ card: Card) {
        guard let selectedCardIndex = cardsOnScreen.firstIndex(of: card) else { return }

        cardsOnScreen[selectedCardIndex].state.toggle()
    }

    /// Check selected cards are matching or not.
    /// And update score.
    mutating func checkSelectedCards() {
        let selectedCardIndices = cardIndices(of: .selected)

        if selectedCardIndices.count == 3 {
            let selectedCards = selectedCardIndices.map { cardsOnScreen[$0] }
            let isValidSet = isSet(selectedCards) || isCheatModeOn

            for index in selectedCardIndices {
                if isValidSet {
                    cardsOnScreen[index].state = .matched
                } else {
                    cardsOnScreen[index].state = .unmatched
                }
            }

            score += isValidSet ? 1 : -1
        }
    }

    /// Unselects unmatched cards
    mutating func unselectUnmatchedCards() {
        let unmatchedCardIndices = cardIndices(of: .unmatched)

        if unmatchedCardIndices.count > 0 {
            for index in unmatchedCardIndices {
                cardsOnScreen[index].state = .unselected
            }
        }
    }

    /// Adds `card` to `cardsOnScreen` and removes it from `deck`
    /// If `insertAt` parameter specified, Inserts new card to that index.
    mutating func dealCard(insertAt index: Int? = nil) {
        guard deck.count > 0 else { return }

        let card = deck.removeFirst()

        if let index, index < cardsOnScreen.count {
            cardsOnScreen.insert(card, at: index)
        } else {
            cardsOnScreen.append(card)
        }
    }

    /// Removes the card from `cardOnScreen` at the specified position.
    /// And adds that card to `discardPile`
    mutating func removeCard(at index: Int) {
        guard index < cardsOnScreen.count else { return }

        let card = cardsOnScreen.remove(at: index)
        discardPile.append(card)
    }

    /// Checks whether the given `cards` make a set or not
    func isSet(_ cards: [Card]) -> Bool {
        let colorComparison = cards.allCompare(\.color)
        let numberComparison = cards.allCompare(\.number)
        let shadingComparison = cards.allCompare(\.shading)
        let shapeComparison = cards.allCompare(\.shape)

        let colorIsSet = colorComparison == .allSame || colorComparison == .allDifferent
        let numberIsSet = numberComparison == .allSame || numberComparison == .allDifferent
        let shadingIsSet = shadingComparison == .allSame || shadingComparison == .allDifferent
        let shapeIsSet = shapeComparison == .allSame || shapeComparison == .allDifferent

        return colorIsSet && numberIsSet && shadingIsSet && shapeIsSet
    }

    /// Toggles cheat mode
    mutating func toggleCheatMode() {
        isCheatModeOn.toggle()
    }
}
