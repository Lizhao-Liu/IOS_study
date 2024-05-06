//
//  Concentration.swift
//  Concentration
//
//  Created by Lizhao Liu on 06/05/2022.
//

import Foundation

struct Concentration {
    private(set) var cards = [Card]()
    private var numberOfPairsOfCards: Int
    var isCompleted: Bool = false
    private var numberOfPairsOfMatchedCards = 0 {
        didSet {
            if numberOfPairsOfMatchedCards == numberOfPairsOfCards {
                isCompleted = true
            }
        }
    }
    
    private var indexOfTheOnlyFaceUpCard : Int? {
        get {
            cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
//            var foundIndex: Int?
//            for index in cards.indices {
//                if(cards[index].isFaceUp) {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
                                         
            }
        }
    }
    
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfTheOnlyFaceUpCard, matchIndex != index {
                if(cards[matchIndex] == cards[index]) {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    numberOfPairsOfMatchedCards += 1
                }
                cards[index].isFaceUp = true
            } else {
                indexOfTheOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        self.numberOfPairsOfCards = numberOfPairsOfCards
        //in 后面加sequence类, e.g. string, array, range
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            //let matchingCard = card //a copy of card
            //let matchingCard = Card(identifier: identifier)
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}


