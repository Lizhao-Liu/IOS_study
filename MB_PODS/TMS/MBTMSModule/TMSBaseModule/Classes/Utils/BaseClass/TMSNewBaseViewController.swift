//
//  TMSNewBaseViewController.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/7.
//

import MBUIKit
import Foundation

@objc
public class TMSNewBaseViewController: MBBaseViewController {
    
    @objc public func ymm_doBack() {
        if (self.navigationController?.viewControllers.count == 1) {
            self.navigationController?.dismiss(animated:true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        MBBaseViewController.setDefaultNavbarThemeWithValue(MBNavbarTheme(rawValue: 1)!)
        
        let backImage = UIImage.img(fromBundle: "TMSBaseModule", withNamed: "ic_back")
        let backItem = UIBarButtonItem.init(image: backImage, style: .plain, target: self, action: #selector(ymm_doBack))
        self.navigationItem.leftBarButtonItem = backItem;
        
        
        if #available(iOS 13.0, *){
            
            let appearance = UINavigationBarAppearance.init()
            appearance.backgroundEffect = UIBlurEffect.init(style: UIBlurEffect.Style.regular)
            appearance.backgroundColor = UIColor.white // 背景色
            
            // 背景色
            var blank: UIImage? = nil
            if nil == blank {
                UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
                blank = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            appearance.shadowImage = blank
            
            // 去除底部阴影横线
            self.navigationController?.navigationBar.standardAppearance = appearance
            if #available(iOS 15.0, *){
                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance;
            }
            
        }
    }
}

extension TMSNewBaseViewController: TMSBaseUICommonProtocol {
    
    public func tms_createUI() -> () {
        
    }
    public func tms_createLayout() -> () {

    }
}
