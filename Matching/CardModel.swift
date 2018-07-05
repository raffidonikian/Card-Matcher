//
//  CardModel.swift
//  Matching
//
//  Created by aml on 6/15/18.
//  Copyright © 2018 aml. All rights reserved.
//

import Foundation




extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

class CardModel {
    
    func getCards() -> [Card] {
        var generatedCardArray = [Card]()
        let used = NSMutableSet()
        var count = 0
        
        while count < 8 {
            let x = arc4random_uniform(13) + 1
            if (!used.contains(x)) {
                used.add(x)
                let card = Card()
                let card2 = Card()
                card.imageName = "card" + String(x)
                card2.imageName = "card" + String(x)
                generatedCardArray.append(card)
                generatedCardArray.append(card2)
                count += 1
            }
            //TODO: randomize location of cards in array
        }
        generatedCardArray.shuffle()
    
        return generatedCardArray
    }
    
}
