//
//  ViewController.swift
//  Matching
//
//  Created by aml on 6/14/18.
//  Copyright © 2018 aml. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timeLeft: UILabel!
    var timer:Timer?
    var milliseconds:Float = 30000
    
    var model = CardModel()
    var cardArray = [Card]()
    var soundManager = SoundManager()
    
    var firstFlippedCardIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardArray = model.getCards()
        collectionView.delegate = self
        collectionView.dataSource = self
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerDone), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        soundManager.playSound(effect: .shuffle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.setCard(cardArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (milliseconds <= 0) {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        if (card.isFlipped) {
            //cell.flipBack()
        }
        else {
            cell.flip()
            soundManager.playSound(effect: .flip)
            //determine if first or second card flipped over
            if (firstFlippedCardIndex == nil) {
                firstFlippedCardIndex = indexPath
            }
            //second card flipped
            else {
                checkForMatches(indexPath)
            }
        }
    }
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        let firstCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let secondCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        if (cardOne.imageName == cardTwo.imageName) {
            // its a match
            soundManager.playSound(effect: .match)
            cardOne.isMatched = true
            cardTwo.isMatched = true
            firstCell?.remove()
            secondCell?.remove()
            checkIfGameEnded()
            
        }
        else {
            // not a match
            soundManager.playSound(effect: .nomatch)
            firstCell?.flipBack()
            cardOne.isFlipped = false
            secondCell?.flipBack()
            cardTwo.isFlipped = false
        }
        if (firstCell == nil) {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
    }
    
    func checkIfGameEnded() {
        var won = true
        for card in cardArray {
            if (card.isMatched == false) {
                won = false
            }
        }
        
        var title = ""
        var message = ""
        if (won == true) {
            timer?.invalidate()
            title = "Congratulations!"
            message = "You Won!"
        }
        
        else {
            if milliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You Lost!"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction((alertAction))
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc
    func timerDone() {
        self.milliseconds -= 1
        let seconds = String(format: "%.2f", milliseconds/1000)
        timeLeft.text = "Time Remaining: \(seconds)"
        if (milliseconds <= 0) {
            timer?.invalidate()
            checkIfGameEnded()
        }
    }
    

        
}

