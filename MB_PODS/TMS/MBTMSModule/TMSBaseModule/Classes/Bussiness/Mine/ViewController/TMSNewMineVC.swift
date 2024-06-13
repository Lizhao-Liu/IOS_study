//
//  TMSNewMineVC.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/13.
//

import Foundation
import MBCommonUILib
import MBUIKit
import UIKit
import MBVersionModule
import MBXarLib
import MBLogLib
import MBDoctorService

public typealias TypeCommonBlock = (() -> Void)

@objc public class TMSNewMineVC: TMSNewBaseViewController {

    private lazy var dataSource = [Array<TMSMineModel>]()
    private lazy var versionManager: MBVersionManager = MBVersionManager()
    private var leftBarBtnItem: UIBarButtonItem?
    private var lastTimeStamp: Double = 0

    public func mb_pageName() -> String! {
        "tms_mine_tab"
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leftBarBtnItem = self.navigationItem.leftBarButtonItem ?? nil
        self.navigationItem.leftBarButtonItem = nil
        navigationController?.navigationBar.shadowImage = UIImage()
        self.queryUserInfoRequest()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    public override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(tab_selected_changed), name:NSNotification.Name(TMSKEY_NOTI_TAB_SELECTED_CHANGED) , object: nil)

        self.initData()
        self.tms_createUI()
        self.tms_createLayout()
    }
    
    public func queryUserInfoRequest() {
        TMSPorfileVC.queryUserInfoWithSuccess { [weak self] () in
            self?.initData()
        }
    }
    
    public func initData() {
        self.dataSource.removeAll() // 更新数据
        let version:String = TMSUserManager.shared().deviceInfo?.appversion ?? "1.0.0";

        let versionModel:TMSMineModel = TMSMineModel()
        versionModel.title = "当前版本：V\(version)"
        versionModel.content = "检查更新"
        versionModel.selectorStr = NSStringFromSelector(#selector(gotoCheckVersion));
        
        let contactModel:TMSMineModel = TMSMineModel()
        contactModel.title = "联系客服";
        contactModel.content = TMSUserManager.shared().userInfo?.serviceHotline ?? "";
        contactModel.selectorStr = NSStringFromSelector(#selector(gotoContactUs));

        let array = [versionModel,contactModel];
        self.dataSource.append(array)

        let setListArray = TMSUserManager.shared().userInfo?.dataList ?? []
        if (setListArray.count > 0) {
            self.dataSource.append(setListArray)
        }
        self.tableView.reloadData()
        
        if (TMSUserManager.shared().userInfo != nil) {
            mineInfoView.mb_config(withItemModel: TMSUserManager.shared().userInfo)
        }
    }
    
    public override func tms_createUI() {
        self.title = "我的";
        self.view.backgroundColor = UIColor.init("#F7F7F7");
        
        self.view.addSubview(self.mineInfoView)
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.tableView)
    }
    
    public override func tms_createLayout() {
        self.mineInfoView.mas_makeConstraints { make in
            make?.top.left()?.right()?.mas_equalTo()(0)
        }
        
        self.contentView.mas_makeConstraints { make in
            make?.top.mas_equalTo()(self.mineInfoView.mas_bottom)?.offset()(MBFit(a:10))
            make?.left.mas_equalTo()(MBFit(a:10));
            make?.right.mas_equalTo()(MBFit(a:-10));
            make?.bottom.mas_equalTo()(self.view.mas_bottom)
        }

        self.tableView.mas_makeConstraints { make in
            make?.edges.mas_equalTo()(0);
        }
    }
    
    private func setUpdateFlag(value: Bool) {
        let key = TMSNewMineVC.cacheUserInfoKey(key:"CheckUpdate_Click_aboutUs") ?? "CheckUpdate_Click";
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    private func getUpdateFlag() -> Bool {
        let key = TMSNewMineVC.cacheUserInfoKey(key:"CheckUpdate_Click_aboutUs") ?? "CheckUpdate_Click";
        let value = UserDefaults.standard.bool(forKey:key);
        return value;
    }
    
    @objc func gotoCheckVersion(){
        //获取当前时间
        let nowTimeInterval = Double(truncating: NSDate.mb_millSecondsNumberSince1970())
        if (nowTimeInterval - lastTimeStamp) < 1000 {
            return;
        }
        lastTimeStamp = nowTimeInterval;
        
        MBDoctorUtil.tap(withPageName: mb_pageName(), referPageName: "", elementId: "check_update", extra: [:])
        // 1、检查宿主工程是否有版本更新，如果有直接跳转app store
        // 1.网络请求成功与否  2.是否需要更新 3.appStoreUrl 4. 错误信息
        self.versionManager.checkoutAppVersionCompleted { [weak self] (requestSuccess, appNeedUpdate, appStoreUrl, errorMsg) in
            
            guard let tempSelf = self else {
                return
            }
            guard requestSuccess else {
                MBToastView.toastTitle(errorMsg ?? "检查更新异常，请稍后重试")
                return
            }
            if (appNeedUpdate) { // App需要更新
                //app首页的升级提醒的弹窗，如果点击“知道了”，会保存时间到本地，下次打开app，没超过24小时的话，不再弹窗提示
                //如果用户在“我的”页面，手动检查版本更新，则把本地缓存的时间清除掉，防止没超过24小时的话，没有弹窗
                UserDefaults.standard.removeObject(forKey: "kUserDefault_AlertTime")
                
                let selector:Selector  = NSSelectorFromString("versionUpdateHandle");
                if let method = class_getInstanceMethod(type(of: tempSelf.versionManager), selector) {
                    let imp = method_getImplementation(method)
                    typealias Function = @convention(c) (AnyObject, Selector, Any?) -> Void
                    let function = unsafeBitCast(imp, to: Function.self)
                    function(tempSelf.versionManager, selector, nil)
                }
                
            } else {
                MBToastView.toastTitle("当前已经是最新版本")
                
                MBModuleError("Xray tms fetchXrayUpgradeTask first step!")
                UserDefaults.standard.setValue(true, forKey: "\(TMSNewMineVC.cacheUserInfoKey(key:"CheckUpdate_Click_aboutUs") ?? "CheckUpdate_Click")")
                UserDefaults.standard.synchronize()
                MBXarLoader.instance().fetchXrayUpgradeTask { (needUpdate) in
                    let isUserClicked: Bool = UserDefaults.standard.bool(forKey: "\(TMSNewMineVC.cacheUserInfoKey(key:"CheckUpdate_Click_aboutUs") ?? "CheckUpdate_Click")")
                    if !isUserClicked {
                        return
                    }
                    guard let tempSelf = self else {
                        return
                    }
                    guard needUpdate else { // 不需要更新时判断
                        if MBXarLoader.instance().queryXrayEffectiveSources() {
                            tempSelf.showDownloadSuccessAlert()
                            return
                        } else {
//                                tempSelf.showAlert(with: "当前已是最新版本")
                            return
                        }
                    }
                    
//                        MBToastView.toastTitle("资源下载中，请勿离开当前页面...", interval: 2)
                    
                    MBModuleError("Xray tms resourse downloading second step!")
                    MBXarLoader.instance().allBizDownloadSuccessBlock = { (downloadSuccess) in
                        UserDefaults.standard.setValue(false, forKey: "\(TMSNewMineVC.cacheUserInfoKey(key: "CheckUpdate_Click_aboutUs") ?? "CheckUpdate_Click")")
                        UserDefaults.standard.synchronize()
                        guard downloadSuccess else {
                            MBToastView.toastTitle("当前网络繁忙，请稍后重试")
                            return
                        }
                        if let tempSelf = self {
                            tempSelf.showDownloadSuccessAlert()
                        }
                    }
                }
            }
        }
        
    }
    fileprivate func showDownloadSuccessAlert() {
        // 下载成功提醒
//        let successAlertString: String? = MBConfigCenter.getStringConfig("auth", key: "restartDialogContent")
//        let alertView = MBUniversalAlertView.init(title: "提示", message: successAlertString ?? "已为您下载好最新资源包，是否立即重启生效？")
//        let cancleButton = MBUniversalAlertButton.init(title: "下次再说")
//        let sureButton = MBUniversalAlertButton.init(title: "立即重启", titleColor: "#FA871E") {
//            exit(0)
//        }
//        alertView.addButton(cancleButton)
//        alertView.addButton(sureButton)
//        UIViewController.mb_current()!.present(alertView, animated: false, completion: nil)
        
        // 下载成功提醒 重启生效
        MBModuleError("Xray tms Download Success，Waiting For Restart!")
    }
    
    
    // MARK ------- Action --
    /// 切换tab 通知监听
    @objc func tab_selected_changed(noti: NSNotification) {
        if (UIViewController.mb_current()?.className == self.className) {
            // self.queryUserInfoRequest()
        }
    }
    
    @objc func gotoContactUs() {
        guard let phone = TMSUserManager.shared().userInfo?.serviceHotline else { return }
        phone.makePhoneCall()
    }

    @objc func gotoNextPage(schema:String) {
        TMSRouterCenter.tms_performWithURLString(schema, params: ["fullscreen" : true])
    }
    
    @objc func didClickMineView(_ sender:UILongPressGestureRecognizer) {
        let vc = TMSPorfileVC();
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc static func cacheUserInfoKey(key: String) -> String? {
        guard let userId: String = TMSUserManager.shared().userInfo?.userId else {
            return nil
        }
        if (userId.count <= 0) {
            return nil
        }
        let encodedUserId = userId.mb_utf8EncodeData().mb_base64EncodedString()
        let newKey: String =  String(format: "%@_%@", encodedUserId, key)
        print(newKey)
        return newKey
    }
    
    
    
    
    //MARK ------- Properties
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.layer.shadowColor = UIColor.init(white: 0, alpha: 0.03).cgColor;
        contentView.layer.shadowOffset = CGSize(width: 0,height: 5);
        contentView.layer.shadowOpacity = 1;
        contentView.layer.shadowRadius = 10;
        return contentView
    }()
    
    private lazy var mineInfoView: TMSMineTopInfoView = {
        let mineInfoView = TMSMineTopInfoView()
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didClickMineView(_:)))
        mineInfoView.addGestureRecognizer(tap)
        
        return mineInfoView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.init("#F7F7F7")
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = MBFit(51);
        tableView.isScrollEnabled = false;
        tableView.layer.masksToBounds = true;
        tableView.layer.cornerRadius = MBFit(6);
        tableView.separatorColor = UIColor(hexString: "#e5e5e5")
        tableView.register(TMSMineTableViewCell.self, forCellReuseIdentifier: TMSMineTableViewCell.className)
        return tableView
    }()
    
    
    
    
}

extension TMSNewMineVC : UITableViewDataSource {
        
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectonArray = dataSource[section]
        return sectonArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:TMSMineTableViewCell? = tableView.dequeueReusableCell(withIdentifier: TMSMineTableViewCell.className, for: indexPath) as? TMSMineTableViewCell
        if (cell == nil) {
            cell = TMSMineTableViewCell.init(style: .default, reuseIdentifier: TMSMineTableViewCell.className)
        }
        
        let sectionArray = dataSource[indexPath.section]
        let model:TMSMineModel = sectionArray[indexPath.row];
        cell?.mb_config(withItemModel: model)
        cell?.line.isHidden = indexPath.row == (sectionArray.count - 1);

        return cell!
    }
}

extension TMSNewMineVC : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return MBFit(a: 10)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionArray = dataSource[indexPath.section]
        let model:TMSMineModel = sectionArray[indexPath.row];
            
        if (model.selectorStr.count > 0){
            let selector:Selector  = NSSelectorFromString(model.selectorStr);
            if let method = class_getInstanceMethod(type(of: self), selector) {
                let imp = method_getImplementation(method)
                typealias Function = @convention(c) (AnyObject, Selector, Any?) -> Void
                let function = unsafeBitCast(imp, to: Function.self)
                function(self, selector, nil)
            }
            return
        }
        
        if model.schema.count > 0 {
            self.gotoNextPage(schema: model.schema)
            return
        }
                
    }
}
