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
        // Unselect appended card
        didSet {
            let endIndex = discardPile.endIndex - 1

            var card = discardPile[endIndex]
            card.state = .unselected

            discardPile[endIndex] = card
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

    /// Returns the cards in `cardsOnScreen` that have the given `state`.
    func cardsWhich(_ state: Card.State) -> [Card] {
        cardsOnScreen
            .filter { $0.state == state }
    }

    /// Toggles given `card`'s state as selected or unselected.
    mutating func choose(_ card: Card) {
        guard let selectedCardIndex = cardsOnScreen.firstIndex(of: card) else { return }

        cardsOnScreen[selectedCardIndex].state.toggle()
    }

    /// Updates card state at given index with given state.
    mutating func updateCardState(_ card: Card, with state: Card.State) {
        guard let index = cardsOnScreen.firstIndex(of: card) else { return }

        cardsOnScreen[index].state = state
    }

    /// Updates `score` with given value.
    mutating func updateScore(with value: Int) {
        score += value
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
    /// Returns index of the card
    @discardableResult
    mutating func removeCard(_ card: Card) -> Int? {
        guard let index = cardsOnScreen.firstIndex(of: card) else { return nil }

        let card = cardsOnScreen.remove(at: index)
        discardPile.append(card)

        return index
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
