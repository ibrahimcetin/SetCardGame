//
//  SetCardGameViewModelTests.swift
//  SetCardGameTests
//
//  Created by İbrahim Çetin on 22.03.2023.
//

import XCTest
@testable import SetCardGame

final class SetCardGameViewModelTests: XCTestCase {

    private var viewModel: SetCardGameViewModel!

    override func setUp() {
        viewModel = SetCardGameViewModel()
    }

    func testInitials() {
        XCTAssertEqual(viewModel.deck.count, 69)
        XCTAssertEqual(viewModel.cardsOnScreen.count, 12)
        XCTAssertEqual(viewModel.discardPile.count, 0)
    }

    func testChoose() throws {
        var card = try XCTUnwrap(viewModel.cardsOnScreen.first)
        viewModel.choose(card)

        card.state = .selected
        let selectedCard = try XCTUnwrap(viewModel.cardsOnScreen.first(where: { $0 == card }))

        XCTAssertEqual(selectedCard, card)
    }

    func testDealCard() {
        for _ in 0..<3 {
            viewModel.dealCard()
        }

        XCTAssertEqual(viewModel.cardsOnScreen.count, 15)
    }

    func testToggleCheatMode() {
        viewModel.toggleCheatMode()

        XCTAssertTrue(viewModel.isCheatModeOn)

        viewModel.toggleCheatMode()

        XCTAssertFalse(viewModel.isCheatModeOn)
    }

    func testScore() {
        for index in 0..<3 {
            let card = viewModel.cardsOnScreen[index]
            viewModel.choose(card)
        }

        XCTAssert(viewModel.score == -1 || viewModel.score == 1)
    }


    func testNewGame() {
        let currentDeck = viewModel.deck
        let currentCardsOnScreen = viewModel.cardsOnScreen

        viewModel.newGame()

        XCTAssertNotEqual(viewModel.deck, currentDeck)
        XCTAssertNotEqual(viewModel.cardsOnScreen, currentCardsOnScreen)
        XCTAssertEqual(viewModel.discardPile.count, 0)
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertEqual(viewModel.isCheatModeOn, false)
    }

    func testDiscardPile() {
        viewModel.toggleCheatMode()

        XCTAssertTrue(viewModel.isCheatModeOn)

        for index in 0..<3 {
            viewModel.choose(viewModel.cardsOnScreen[index])
        }
        viewModel.choose(viewModel.cardsOnScreen[0])

        XCTAssertEqual(viewModel.discardPile.count, 3)

        for card in viewModel.discardPile {
            XCTAssertEqual(card.state, .unselected)
        }
    }
}
