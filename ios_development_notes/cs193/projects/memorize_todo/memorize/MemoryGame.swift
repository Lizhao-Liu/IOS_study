//
//  MemoryGame.swift
//  memorize
//
//  Created by Lizhao Liu on 15/04/2022.
//

import Foundation

struct MemoryGame<CardContent> {
    private(set) var cards : Array<Card>
    private var theOnlyFaceUpCardIndex : Int?
    
    mutating func choose(_ card: Card){ //choosing labels is important see the reading assignment
        //if let cardIndex = index(of: card){ //let cardIndex = index(of: card)!
        if  let cardIndex = cards.firstIndex(where: {aCardIndex in aCardIndex.id == card.id}){ //where {$0.id == card.id}
           cards[cardIndex].isFaceUp.toggle() //struct is immutable
        }
        print("\(cards)")
        
    }
    func index(of card: Card) -> Int? {
        for index in 0..<cards.count {
            if cards[index].id == card.id{
                return index
            }
        }
        return nil
    }
    init(numbersOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) { //我们设置了init，free init就不能再用了
        cards = Array<Card>()
        for pairIndex in 0..<numbersOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex*2, content: content))
            cards.append(Card(id: pairIndex*2+1, content: content))
        }
    }
    struct Card: Identifiable{
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}

