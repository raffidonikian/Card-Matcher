//
//  CardCollectionViewCell.swift
//  Matching
//
//  Created by aml on 6/15/18.
//  Copyright © 2018 aml. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var front: UIImageView!
    @IBOutlet weak var back: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        self.card = card
        self.front.image = UIImage(named: card.imageName)
        
        if (card.isMatched == true) {
            back.alpha = 0
            front.alpha = 0
            return
        }
        else {
            back.alpha = 1
            front.alpha = 1
        }
        
        if (card.isFlipped) {
            self.flip()
        }
        else {
            UIView.transition(from: self.front, to: self.back, duration: 0.01, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip() {
        UIView.transition(from: back, to: front, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        self.card?.isFlipped = true
    }
    
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.front, to: self.back, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        
    
    }
    
    func remove() {
    
        self.back.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {self.front.alpha = 0},
                       completion: nil)
        
        
        
        
        
    }
}
