//
//  ArrayExtensionsTests.swift
//  SetCardGameTests
//
//  Created by İbrahim Çetin on 22.03.2023.
//

import XCTest
@testable import SetCardGame

final class ArrayExtensionsTests: XCTestCase {

    func testAllCompareAllSame() {
        let cards: [Card] = Array(repeating: Card.sample, count: 3)

        XCTAssertEqual(cards.allCompare(\.color), .allSame)
    }

    func testAllCompareAllDifferent() {
        let cards: [Card] = [
            Card(color: .red, number: .one, shading: .solid, shape: .diamond, state: .selected, id: 0),
            Card(color: .red, number: .two, shading: .solid, shape: .diamond, state: .selected, id: 1),
            Card(color: .red, number: .three, shading: .solid, shape: .diamond, state: .selected, id: 2),
        ]

        XCTAssertEqual(cards.allCompare(\.number), .allDifferent)
    }

    func testAllCompareNone() {
        let cards: [Card] = [
            Card(color: .red, number: .one, shading: .striped, shape: .diamond, state: .selected, id: 0),
            Card(color: .red, number: .one, shading: .striped, shape: .diamond, state: .selected, id: 0),
            Card(color: .red, number: .one, shading: .open, shape: .diamond, state: .selected, id: 0),
        ]

        XCTAssertEqual(cards.allCompare(\.shading), .none)
    }

}
