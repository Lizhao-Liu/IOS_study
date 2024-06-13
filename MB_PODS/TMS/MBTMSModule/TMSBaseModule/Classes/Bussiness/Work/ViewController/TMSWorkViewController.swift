//
//  TMSWorkViewController.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/16.
//

import Foundation
import MBCommonUILib
import MBUIKit
import UIKit
import Masonry
import AdSupport
import AppTrackingTransparency
import MBProjectConfig
import MBNetworkLib

@objc public class TMSWorkViewController: TMSNewBaseViewController {
    
    private let headHeight = UIApplication .shared.statusBarFrame.height + MBFit(26) + MBFit(56)

    private var workDataModel:TMSWorkDataModel?
    private var expiringRenewalModel: TMSWorkExpiringRenewalModel?
    private var isFirstShowRenewalWindow: Bool = true
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MBDoctorUtil.view(withPage: "tmsapp_shouye", referPage: nil, elementId: "pageview", extra:nil, context: nil)
        self.getExpiringRenewalState()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MBDoctorUtil.view(withPage: "tmsapp_shouye", referPage: nil, elementId: "pageview_stay_duration", extra:nil, context: nil)
    }
    
    public override func viewDidLoad(){
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tab_selected_changed), name:NSNotification.Name(TMSKEY_NOTI_TAB_SELECTED_CHANGED) , object: nil)

        self.initData()
        self.tms_createUI()
        self.tms_createLayout()
        // 预加载下用户信息数据，RN 可能会用到
        TMSPorfileVC.queryUserInfoWithSuccess(queryBack: nil)
        
        self.requestTrackingAuthorization()
    }
    
    public override func tms_createUI() {
        self.view.backgroundColor = UIColor.init("#F7F7F7");
        
        self.view.addSubview(self.headView)
        self.view.addSubview(self.bannerView)
        self.view.addSubview(self.functionView)
        
        self.headView.tipOnClickBlock = { [weak self] () in
            self?.showExpiringRenewal()
        }
    }
    
    @objc public override func tms_createLayout() {
 
    }
    
    // 隐藏导航栏
    @objc public override func mb_isNaviBarHidden() -> Bool {
        return true;
    }
    
    // iOS 15 审核被拒 要求授权弹框
    public func requestTrackingAuthorization() {
        if #available(iOS 14.5, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                if (status == .authorized) {
                    MBModuleInfo("TMSBaseModule", "requestTrackingAuthorization.authorized")
                }
            }
        }
    }
    
    /// 切换tab 通知监听
    @objc func tab_selected_changed(noti: NSNotification) {
        if (UIViewController.mb_current()?.className == self.className) {
            self.initData()
        }
    }
    
    
    // MARK ----- 加载数据 --
    public func initData() {
        if let homepageData = UserDefaults.standard.object(forKey: "queryHomepageInfo")  {
            self.workDataModel = TMSWorkDataModel.yy_model(withJSON: homepageData)
            if let dataModel = self.workDataModel {
                self.updateUI(result: dataModel)
            } else {
                self.view.tms_startLoading()
            }
        } else{
            self.view.tms_startLoading()
        }
        self.getFunctionListData()
    }
    
    public func getFunctionListData() {
        
        TMSNetwork.post(withPath: "/yzg-saas-permission-app/yzgApp/user/queryHomepageInfo", params: nil, expect: TMSWorkDataModel.self) { [weak self] (result) in
            
            guard let resultJson = result as? TMSWorkDataModel else {
                fatalError("queryUserInfo back change to TMSUserModel failed")
            }
            
            // 遇到 resultJson.yy_modelToJSONData 错误写法。没有告警 报错。直接崩溃
            UserDefaults.standard.set(resultJson.yy_modelToJSONData(), forKey: "queryHomepageInfo")
            UserDefaults.standard.synchronize()
            self?.view.tms_endLoading()
            self?.workDataModel = resultJson
            self?.updateUI(result: resultJson)

        } onFailed: { error in
            let message:String? =  error.message ?? "网络请求失败"
            self.view.tms_endLoading(withTip: message!)
        }
    }
    
    public func getExpiringRenewalState() {
        TMSNetwork.post(withPath: "/yzg-saas-permission-app/yzgApp/appExpiringRenewal/appDisplayExpiringRenewal", params: nil, expect: TMSWorkExpiringRenewalModel.self) { [weak self] (result) in
            
            guard let resultModel: TMSWorkExpiringRenewalModel = result as? TMSWorkExpiringRenewalModel else {
                fatalError("ExpiringRenewalState back change to TMSWorkExpiringRenewalModel failed")
            }
            self?.expiringRenewalModel = resultModel
            DispatchQueue.main.async {
                guard let selfVC = self else { return }
                if (resultModel.displayBtnFlag) {
                    selfVC.headView.updateTipBtn(isShow: resultModel.displayBtnFlag)
                }
                if (resultModel.autoWindowFlag) {
                    if (selfVC.isFirstShowRenewalWindow) {
                        selfVC.isFirstShowRenewalWindow = false
                        selfVC.showExpiringRenewal()

                    }
                }
            }
            
        } onFailed: { error in
            MBModuleError("TMSBaseModule", "getexpiringRenewalState fails")
        }
    }
    
    
    public func updateUI(result:TMSWorkDataModel) {
        
        var imageArr = Array<String>()
        if let bannerList = self.workDataModel?.bannerList  {
            for banner in bannerList {
                if !banner.picUrl.isEmpty {
                    imageArr.append(banner.picUrl)
                }
            }
        } 
  
        self.bannerView.updateFunctionViews(model: imageArr)
        
        self.functionView.updateFunctionViews(model: result.functionList)

    }
    
    private func didClickBannerView(index:Int) {
        
        if let bannerList = self.workDataModel?.bannerList,index <= bannerList.count  {
            let model:TMSWorkBannerModel = bannerList[index]
            self.gotoOtherPageWithUrl(urlStr: model.directUrl)
        }
    }
    
    private func didClickItemView(indexPath:IndexPath) {
        
        if let functionList = self.workDataModel?.functionList,indexPath.row <= functionList.count  {
            let model:TMSWorkFunctionModel = functionList[indexPath.row]
            
            if model.protocol.isEmpty {
                MBGTipView.showTip(model.toastMsg)
                return
            }
            self.gotoOtherPageWithUrl(urlStr: model.protocol)
        }
    }
    
    private func gotoOtherPageWithUrl(urlStr:String?) {
        
        guard let urlStr = urlStr else {
            return
        }
        TMSRouterCenter.tms_performWithURLString(urlStr, params: nil)
    }
    
    private func showExpiringRenewal() {
        guard let popupWindowRouterUrl: String = self.expiringRenewalModel?.popupUrl else { return }
        TMSRouterCenter.tms_presenterWithURLString(popupWindowRouterUrl, params: nil)
    }
    
    
    // MARK ------- lazyInit
    // 注意关键字 lazy 以及{} 后跟()初始化，不写布局崩溃 couldn't find a common superview for ...
    private lazy var headView : TMSWorkNewHeadView = {
        let headView = TMSWorkNewHeadView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: headHeight))
        return headView
    }()

    private lazy var bannerView : TMSWorkNewBannerView = {
        let bannerView = TMSWorkNewBannerView.init(frame: CGRect.init(x: 0, y: headHeight, width: kScreenWidth, height: MBFit(147)))
        bannerView.workBannerViewBlock = { [weak self] (index:Int) in
            self?.didClickBannerView(index: index)
        }
        return bannerView
    }()
    
    private lazy var functionView : TMSWorkFunctionsView = {
        let bannerMarginTop : CGFloat = headHeight + MBFit(147)
        let functionView = TMSWorkFunctionsView.init(frame: CGRect.init(x: 0, y: bannerMarginTop, width: kScreenWidth, height: kScreenHeight - bannerMarginTop - CGFloat(kSafeAreaBottomHeight) - 50))
        functionView.workFunctionsViewBlock = { [weak self] (indexPath:IndexPath) in
            self?.didClickItemView(indexPath: indexPath)
        }
        return functionView
    }()

    
}
