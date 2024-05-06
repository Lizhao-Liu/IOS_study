//
//  memorizeApp.swift
//  memorize
//
//  Created by Lizhao Liu on 03/04/2022.
//

import SwiftUI

@main
struct memorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
