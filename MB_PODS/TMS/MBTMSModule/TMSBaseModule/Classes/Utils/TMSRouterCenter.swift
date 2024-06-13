//
//  TMSRouterCenter.swift
//  MBTMSModule
//
//  Created by ymm_lzz on 2022/8/17.
//

import Foundation
import MBFoundation
import MBUIKit
import YMMRouterLib

@objc public class TMSRouterCenter : NSObject {
    
    // 类方法
    @objc public class func tms_performWithURLString(_ urlString: String, params:[AnyHashable: Any]?) {
        
        if NSString.mb_isNilOrEmpty(urlString) {
            return
        }
        
        var routeUrl = urlString
        
        if routeUrl.hasPrefix("http") {
            routeUrl = routeUrl.mb_encodeURIComponent()! as String
            routeUrl = "ymm://view/web?url=\(routeUrl)&useMBWebView=1"
        }
        
        YMMRouterCenter.shared().perform(withURLString: routeUrl, params: params) { response in
            guard let vc = response?.result as? UIViewController else { return }
            UIViewController.mb_current()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc public class func tms_presenterWithURLString(_ urlString: String, params:[AnyHashable: Any]?) {
        
        if NSString.mb_isNilOrEmpty(urlString) {
            return
        }
            
        YMMRouterCenter.shared().perform(withURLString: urlString, params: params) { response in
            guard let vc = response?.result as? UIViewController else { return }
            let rootNav: UINavigationController = UINavigationController(rootViewController: vc)
            rootNav.view.backgroundColor = UIColor.clear;
            rootNav.modalPresentationStyle = .overCurrentContext;
            rootNav.modalTransitionStyle = .crossDissolve;
            
            guard let topVC: UIViewController = UIViewController.mb_current() else { return }
            
            
            if (topVC.navigationController != nil) {
                topVC.navigationController?.present(rootNav, animated: true)
                return
            }
            
            if (topVC.tabBarController != nil) {
                topVC.tabBarController?.present(rootNav, animated: true)
                return;
            }
            topVC.present(rootNav, animated: true)
        }
    }

    
}
