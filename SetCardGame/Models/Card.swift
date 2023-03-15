//
//  Card.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 14.03.2023.
//

import Foundation

struct Card: Identifiable, Equatable {
    let color: Color
    let number: Number
    let shading: Shading
    let shape: Shape

    var state: State = .unselected

    let id: Int

    static let sample = Card(color: .purple, number: .three, shading: .striped, shape: .squiggle, state: .unselected, id: 0)
}

extension Card {
    enum Color: CaseIterable {
        case red
        case green
        case purple
    }
}

extension Card {
    enum Number: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
}

extension Card {
    enum Shading: CaseIterable {
        case solid
        case striped
        case open
    }
}

extension Card {
    enum Shape: CaseIterable {
        case diamond
        case squiggle
        case oval
    }
}

extension Card {
    enum State {
        case matched
        case unmatched

        case selected
        case unselected

        mutating func toggle() {
            switch self {
            case .matched:
                self = .matched
            case .unmatched:
                self = .selected
            case .selected:
                self = .unselected
            case .unselected:
                self = .selected
            }
        }
    }
}
