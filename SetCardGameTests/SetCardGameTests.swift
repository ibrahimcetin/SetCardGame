//
//  SetViewModelTests.swift
//  SetViewModelTests
//
//  Created by İbrahim Çetin on 15.03.2023.
//

import XCTest
@testable import SetCardGame

final class SetViewModelTests: XCTestCase {
    func testScore() {
        let viewModel = SetCardGameViewModel()

        for index in 0..<3 {
            viewModel.choose(viewModel.cardsOnScreen[index])
        }

        XCTAssert(viewModel.score == 1 || viewModel.score == -1)
    }

    func testChoose() throws {
        let viewModel = SetCardGameViewModel()

        var card = try XCTUnwrap(viewModel.cardsOnScreen.randomElement())
        viewModel.choose(card)

        card.state = .selected
        let selectedCard = viewModel.cardsOnScreen.first { $0 == card}

        XCTAssertNotNil(selectedCard)
    }

    func testDealThreeMoreCards() throws {
        let viewModel = SetCardGameViewModel()

        viewModel.dealThreeMoreCards()

        XCTAssertEqual(viewModel.cardsOnScreen.count, 15)
    }

    func testNewGame() {
        let viewModel = SetCardGameViewModel()

        let currentGameCards = viewModel.cardsOnScreen

        viewModel.newGame()

        let newGameCards = viewModel.cardsOnScreen

        XCTAssertNotEqual(currentGameCards, newGameCards)
    }
}
