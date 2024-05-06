//
//  EmojiMemoryGame.swift
//  memorize
//
//  Created by Lizhao Liu on 15/04/2022.
//

import SwiftUI//a part of ui

class EmojiMemoryGame : ObservableObject {
    
    //for classes, every property has to be initialized or set with an init method
    //private(set) other structs or classes can look at it but cannot change it
    static var emojis = ["🐶", "🐮", "🐯", "🐷", "🐭", "🐰", "🐻‍❄️", "🙈","🌵", "🌲", "🍄", "☘️", "🐚", "🌴", "🍃", "🌈"]
    static func createMemoryGame() -> MemoryGame<String>{
        MemoryGame<String>(numbersOfPairsOfCards: 4){ pairIndex in
            emojis[pairIndex]
        }
    }
//    var objectWillChange: ObservableObjectPublisher, when you say something behaves like an obserableObject, you got a hidden var called objectWillChange, and you can use it to publish changes by objectWillChange.send()
        
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
//    func foo(){
//        _ = EmojiMemoryGame.emojis[0]
//    }
    
// MARK: -Intent(s)
    func choose(_ card: MemoryGame<String>.Card){
        objectWillChange.send()
        model.choose(card)
    }
}
