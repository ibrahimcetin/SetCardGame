//
//  SetCardGameApp.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 15.03.2023.
//

import SwiftUI

@main
struct SetCardGameApp: App {
    @StateObject var game = SetViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
