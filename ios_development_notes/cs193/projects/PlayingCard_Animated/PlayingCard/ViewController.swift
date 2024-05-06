//
//  ViewController.swift
//  PlayingCard
//
//  Created by Lizhao Liu on 10/05/2022.
//

import UIKit

class ViewController: UIViewController {
    var deck = PlayingCardDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter {$0.isFaceUp && !$0.isHidden}
    }
    
    private var faceUpCardsMatch: Bool {
        return faceUpCardViews.count == 2
        && faceUpCardViews[0].rank == faceUpCardViews[1].rank
        && faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
            
        }

    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                cardBehavior.removeItem(chosenCardView)
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: {chosenCardView.isFaceUp = !chosenCardView.isFaceUp},
                    completion: {
                        finished in //.ended or not (boot)
                        //这里不存在memory cycle， completion存在于animation system中
                        if self.faceUpCardsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6, //put these magic numbers as a constant struct
                                delay: 0,
                                options: [],
                                animations: {
                                    self.faceUpCardViews.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
                                    }
                                },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            self.faceUpCardViews.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            self.faceUpCardViews.forEach {
                                                $0.isHidden = true
                                                $0.transform = .identity
                                                $0.alpha = 1
                                            }
                                        }
                                    )
                                }
                            )
                        } else if self.faceUpCardViews.count == 2 {
                            self.faceUpCardViews.forEach{ faceUpCard in
                                UIView.transition(
                                    with: faceUpCard,
                                    duration: 0.6,
                                    options: [.transitionFlipFromLeft],
                                    animations: {faceUpCard.isFaceUp = !faceUpCard.isFaceUp},
                                    completion: {finished in self.cardBehavior.addItem(faceUpCard)}
                                )
                            }

                        } else {
                            if !chosenCardView.isFaceUp {
                                self.cardBehavior.addItem(chosenCardView)
                            }
                        }
                    }
                )
            }
            
        default: break
        }
        
    }


}

extension CGFloat {
    var arc4random : CGFloat {
        if self > 0{
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

