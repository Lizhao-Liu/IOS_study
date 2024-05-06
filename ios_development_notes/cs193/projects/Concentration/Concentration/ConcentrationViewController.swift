//
//  ViewController.swift
//  Concentration
//
//  Created by Lizhao Liu on 04/05/2022.
//

import UIKit

class ConcentrationViewController: UIViewController {


    //initialize property before self is created：
    //1. lazy （但是不能使用观察属性）
    //2. 周期方法
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    // 大多数时候model设置为public
    var numberOfPairsOfCards : Int { (visibleCardButtons.count+1) / 2} //read only, public for app
    private(set) var flipCount = 0 { //equal to 0 doesn't call the didSet
        //观察属性
        didSet {
           updateFlipCountLabel()
        }
    }
    @IBOutlet weak var newGameButton: UIButton!
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.black
        ]
        let attributedString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips: \n\(flipCount)" : "Flips: \(flipCount)",
            attributes: attributes)
        flipCountLabel.attributedText = attributedString
        //for UIButton, set attributedTitle
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
           updateFlipCountLabel()
        }
    }
    //command + select the wrong var name and rename
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter{ !$0.superview!.isHidden }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }


    @IBAction func startANewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        flipCount = 0
        updateViewFromModel()
        newGameButton.isHidden = true
    }
    // @IBAction：鼠标滑过方法的行数位置，对应视图的对象会被选中
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = visibleCardButtons.firstIndex(of: sender){
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in card buttons")
        }

    }

    private func updateViewFromModel() {
        if visibleCardButtons != nil { // protecting the code that can be called when your mvc is still being prepared
            for index in visibleCardButtons.indices {
                let card = game.cards[index]
                let button = visibleCardButtons[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = UIColor.lightGray
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? UIColor(white: 1, alpha: 1) : UIColor.darkGray
                }
            }
            if game.isCompleted {
                newGameButton.isHidden=false
            }
        }
    }

    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    private var emojiChoices = "👻🎃🍄🌈🌲🫥🌴😍🐚🌵🍁🐶"
    private var emoji = [Card:String]()
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            //let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }

//    func flipCard(withEmoji emoji: String, on button: UIButton) {
//        if(button.currentTitle == emoji){
//            //通过opt+选中方法，查看文档overview，阅读使用方法
//            //issue:字体样式问题：新版Xcode中，新增的UIButton的Style默认属性为Plain，导致用代码设定了Button字体大小及颜色后，运行，发现进入页面的时候Button的字体和颜色并没有显示为我们代码中设定的值，并且点击按钮后还会改变字体大小和颜色。
//            button.setTitle("", for: UIControl.State.normal)
//            button.backgroundColor = UIColor.orange
//        } else {
//            button.setTitle(emoji, for: UIControl.State.normal)
//            button.backgroundColor = UIColor.white
//        }
//    }
}

extension Int {
    var arc4random :Int {
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

