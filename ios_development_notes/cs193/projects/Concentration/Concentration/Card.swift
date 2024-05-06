//
//  Card.swift
//  Concentration
//
//  Created by Lizhao Liu on 06/05/2022.
//

import Foundation
// structs vs classes
// 1. no inheritance in struct
// 2. structs are value types: pass copies, copy on write
struct Card : Hashable {
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    //no emojis as they belongs to UI
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
