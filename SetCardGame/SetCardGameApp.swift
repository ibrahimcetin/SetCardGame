//
//  SetCardGameApp.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 15.03.2023.
//

import SwiftUI

@main
struct SetCardGameApp: App {
    @StateObject var game = SetCardGameViewModel()

    var body: some Scene {
        WindowGroup {
            SetCardGameView(game: game)
        }
    }
}
