//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Lizhao Liu on 12/05/2022.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
//UISplitViewControllerDelegate: all the methods in it are obj-c optional
    let theme = [
        "Sports" : "⚽️🏀🏈🥎🏓🥏🤿🏸⛸🥊⛳️🎳",
        "Animals" : "🐶🐹🐸🐷🐯🦊🐰🐻🐼🦄🐣🐱",
        "Faces" : "😍🤪😎😇🥹🥳😡🙄🤒🤗😱😫"
    ]
    

    // a function that is called on every object that comes out of your interface builder file
    override func awakeFromNib() {
        super.awakeFromNib()
        //call the method about collapsing on top
        splitViewController?.delegate = self
    }
    
    //should I collapse the details when I am about to adapt the split view controller to iphones
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        //if I collapse the details, return true
        //if I want the details to be collapsed, return false
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }

    private var lastSeguedToConcentrationViewController: ConcentrationViewController?

    //conditional segue
    @IBAction func changeTheme(_ sender: Any) {
        
        //游戏进行中的时候 不可以重启一个游戏 只更换主题设置
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = theme[themeName] {
                cvc.theme = theme
            }
            //手机上没有split view，保留游戏viewcontroller，push到nc中
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = theme[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }

    }



//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = theme[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme //your outlets are not set when you are preparing
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }




}


