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
    private(set) var discardPile: [Card] = []

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

    func cardIndices(of state: Card.State) -> [Int] {
        cardsOnScreen
            .filter { $0.state == state }
            .map { cardsOnScreen.firstIndex(of: $0)! }
    }

    mutating func choose(_ card: Card) {
        let selectedCardIndex = cardsOnScreen.firstIndex(of: card)
        guard let selectedCardIndex else { return }

        cardsOnScreen[selectedCardIndex].state.toggle()

        if cardIndices(of: .selected).count == 3 {
            let selectedCards = cardIndices(of: .selected).map { cardsOnScreen[$0] }
            let allSet = makeASet(selectedCards)

            for index in cardIndices(of: .selected) {
                if allSet || isCheatModeOn {
                    cardsOnScreen[index].state = .matched
                } else {
                    cardsOnScreen[index].state = .unmatched
                }
            }

            if allSet || isCheatModeOn {
                score += 1

                let removedCardIndices = removeMatchedCards()
                dealThreeMoreCards(replaceWith: removedCardIndices)
            } else {
                score -= 1
            }

        } else if cardIndices(of: .unmatched).count > 0 {
            for index in cardIndices(of: .unmatched) {
                cardsOnScreen[index].state = .unselected
            }
        }
    }

    private func makeASet(_ cards: [Card]) -> Bool {
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

    mutating func deal(card: Card) {
        cardsOnScreen.append(card)
        deck.removeAll { $0 == card }
    }

    mutating func dealThreeMoreCards(replaceWith cardIndices: IndexSet? = nil) {
        guard deck.count != 0 else { return }

        if let cardIndices {
            for index in cardIndices {
                cardsOnScreen.insert(deck.removeFirst(), at: index)
            }
        } else {
            cardsOnScreen.append(contentsOf: deck[0..<3])
            deck.removeSubrange(0..<3)
        }
    }

    mutating func removeMatchedCards() -> IndexSet? {
        let cardIndices = IndexSet(cardIndices(of: .matched))

        for index in cardIndices {
            discardPile.append(cardsOnScreen[index])
        }

        cardsOnScreen.remove(atOffsets: cardIndices)

        return cardIndices.isEmpty ? nil : cardIndices
    }

    mutating func toggleCheatMode() {
        isCheatModeOn.toggle()
    }
}
