//
//  TMSNavigationController.swift
//  MBTMSModule
//
//  Created by ymm_lzz on 2022/8/17.
//

import Foundation


@objc
public class TMSNavigationController: UINavigationController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        let topVC:UIViewController? = self.viewControllers.last ?? nil;
        
        let backItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.done, target: topVC, action: nil);
        topVC?.navigationItem.backBarButtonItem = backItem
        
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true;
        }
        
        super.pushViewController(viewController, animated: animated)

    }
    
}
