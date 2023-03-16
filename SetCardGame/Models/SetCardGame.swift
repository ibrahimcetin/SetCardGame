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

    private(set) var score = 0

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

        for _ in 0..<12 {
            let cardIndex = Int.random(in: 0..<deck.count)
            cardsOnScreen.append(deck.remove(at: cardIndex))
        }
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
                cardsOnScreen[index].state = allSet ? .matched : .unmatched
            }

            score += allSet ? +1 : -1

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

    mutating func dealThreeMoreCards() {
        for _ in 0..<min(3, deck.count) {
            let cardIndex = Int.random(in: 0..<deck.count)
            cardsOnScreen.append(deck.remove(at: cardIndex))
        }
    }

    mutating func removeMatchedCards() {
        cardsOnScreen.remove(atOffsets: IndexSet(cardIndices(of: .matched)))
    }
}
