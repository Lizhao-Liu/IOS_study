//
//  TMSPorfileVC.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/7.
//

import Foundation
import MBCommonUILib;
import MBUIKit
import UIKit
import Masonry

public typealias QueryProfileBack = (() -> Void)

// 这样该类所有属性和方法在编译时会自动加上@objc。只有被@objc修饰的属性或方法才被OC类调用到，使用@objcMembers避免了我们为每个属性或方法加@objc 修饰的重复工作
@objc public class TMSPorfileVC: TMSNewBaseViewController {
    
    public override func viewDidLoad(){
        super.viewDidLoad()
        
        self.initData()
        self.tms_createUI()
        self.tms_createLayout()
        
        TMSPorfileVC.queryUserInfoWithSuccess { [weak self] () in
            print("个人信息请求成功返回")
            self?.initData()
        }
    }
    
    public func initData() {
        let headModel:TMSMineModel = TMSMineModel()
        headModel.title = "头像";
        headModel.content = TMSUserManager.shared().userInfo?.avatar ?? "";
        headModel.type = 1;
        
        let nameModel:TMSMineModel = TMSMineModel()
        nameModel.title = "姓名";
        nameModel.content = TMSUserManager.shared().userInfo?.name ?? "";
        nameModel.type = 0;
        
        let phoneModel:TMSMineModel = TMSMineModel()
        phoneModel.title = "手机号";
        phoneModel.content = TMSUserManager.shared().userInfo?.mobile ?? "";
        phoneModel.type = 0;

        self.dataSource = [headModel,nameModel,phoneModel];
        self.tableView.reloadData()
        
        let roles = TMSUserManager.shared().userInfo?.roles
        if (!NSArray.mb_isNilOrEmpty(roles as NSArray?)) {
            let array:NSMutableArray = NSMutableArray.init(capacity: 0);
            // 字符串间用,隔开
            for role in roles! {
                if (!NSString.mb_isNilOrEmpty(role.roleName)) {
                    array.add(role.roleName)
                }
            }
            let roleName:String = array.componentsJoined(by: ";")
            self.roleView.setUpWithRoleName(roleName: roleName)
        }
    }
    
    public override func tms_createUI() {
        self.title = "个人信息";
        self.view.backgroundColor = UIColor.init("#F7F7F7");
        
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.tableView)
        self.view.addSubview(self.roleView)
        
        self.view.addSubview(self.logoutView)
        self.logoutView.addSubview(self.logoutBtn)
        
        self.view.addSubview(self.longPressView)
        
    }
    
    public override func tms_createLayout() {
        self.contentView.mas_makeConstraints { make in
            make?.top.left()?.mas_equalTo()(MBFit(a:10))
            make?.right.mas_equalTo()(MBFit(a:-10))
            make?.height.mas_equalTo()(MBFit(a:153))
        }

        self.tableView.mas_makeConstraints { make in
            make?.edges.mas_equalTo()(0)
        }
        
        self.roleView.mas_makeConstraints { make in
            make?.top.mas_equalTo()(self.contentView.mas_bottom)
            make?.left.mas_equalTo()(MBFit(a:10))
            make?.right.mas_equalTo()(MBFit(a:-10));
            make?.height.mas_greaterThanOrEqualTo()(MBFit(a:51))
        }
        
        self.logoutView.mas_makeConstraints { make in
            make?.top.mas_equalTo()(self.roleView.mas_bottom)?.offset()(MBFit(a:10))
            make?.left.mas_equalTo()(MBFit(a:10))
            make?.right.mas_equalTo()(MBFit(a:-10))
            make?.height.mas_equalTo()(MBFit(a:50))
        }
        
        self.logoutBtn.mas_makeConstraints { make in
            make?.edges.mas_equalTo()(0)
        }
        
        self.longPressView.mas_makeConstraints { make in
            make?.top.mas_equalTo()(self.logoutView.mas_bottom)
            make?.left.right().mas_equalTo()(self.logoutView)
            make?.height.mas_equalTo()(MBFit(a:50))
        }
    }
    
    
    @objc public class func queryUserInfoWithSuccess(queryBack: QueryProfileBack?) {
       
        TMSNetwork.post(withPath: "/yzg-saas-permission-app/yzgApp/user/queryUserInfo", params: nil, expect: TMSUserModel.self) { result in
            
            guard let resultJson = result as? TMSUserModel else {
                fatalError("queryUserInfo back change to TMSUserModel failed")
            }
            
            TMSUserManager.shared().updateUserInfo(with: resultJson, cover: false)
            queryBack?()

        } onFailed: { MBNetworkError in
            let message:String? =  MBNetworkError.message ?? "网络请求失败"
            print("\(message!)")
            MBGTipView.showTip(message)
        }
    }
    
    @objc func didCickLongPressView(_ sender:UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.began) {
            TMSRouterCenter.tms_performWithURLString("ymm://view/xrayinfo", params: nil)
        }
    }
    private func didCickLogupload() {
        TMSRouterCenter.tms_performWithURLString("ymm://view/logupload", params: nil)
    }
    
    @objc func didClickLogoutBtn() {
        
        let alertView:UIAlertController = UIAlertController.init(title: nil, message: "确定要退出登录吗？", preferredStyle: .alert)

        let cancel:UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil);
        let ok:UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { action in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: TMSKEY_NOTI_USERLOGOUT_WILL), object: ["needlogout":true])
        }

        alertView.addAction(ok)
        alertView.addAction(cancel)
        self.present(alertView, animated: true, completion: nil)
    }

    //MARK ------- Properties
    private lazy var dataSource = [TMSMineModel]()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.layer.shadowColor = UIColor.init(white: 0, alpha: 0.03).cgColor;
        contentView.layer.shadowOffset = CGSize(width: 0,height: 5)
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 10
        return contentView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.init("#F7F7F7")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = MBFit(a:51)
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true;
        tableView.layer.cornerRadius = MBFit(6)
        tableView.separatorColor = UIColor(hexString: "#e5e5e5")
        tableView.register(TMSPorfileTableCell.self, forCellReuseIdentifier: TMSPorfileTableCell.className)
        return tableView
    }()
    
    private lazy var roleView: TMSMineRolesView = {
        let roleView = TMSMineRolesView()
        roleView.layer.shadowColor = UIColor.init(white: 0, alpha: 0.03).cgColor;
        roleView.layer.shadowOffset = CGSize(width: 0,height: 5);
        roleView.layer.shadowOpacity = 1
        roleView.layer.shadowRadius = 10
        roleView.longPressBlock =  {[weak self] () in
            self?.didCickLogupload();
        }
        
        return roleView
    }()
    
    private lazy var logoutView: UIView = {
        let logoutView = UIView()
        logoutView.layer.shadowColor = UIColor.init(white: 0, alpha: 0.03).cgColor;
        logoutView.layer.shadowOffset = CGSize(width: 0,height: 5)
        logoutView.layer.shadowOpacity = 1
        logoutView.layer.shadowRadius = 10
        return logoutView
    }()

    private lazy var logoutBtn: UIButton = {
        let logoutBtn = UIButton.init(type: .custom)
        logoutBtn.backgroundColor = UIColor.white
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutBtn.setTitleColor(UIColor(hexString: "#FF3737"), for: .normal)
        logoutBtn.layer.masksToBounds = true
        logoutBtn.layer.cornerRadius = MBFit(3)
        logoutBtn.addTarget(self, action: #selector(didClickLogoutBtn), for: .touchUpInside)
        return logoutBtn
    }()
    
    
    private lazy var longPressView: UIView = {
        let longPressView = UIView()
        let longTap:UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(didCickLongPressView(_:)))
        longTap.minimumPressDuration = 2
        longPressView.addGestureRecognizer(longTap)
        return longPressView
    }()
    
}

extension TMSPorfileVC : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:TMSPorfileTableCell? = tableView.dequeueReusableCell(withIdentifier: TMSPorfileTableCell.className, for: indexPath) as? TMSPorfileTableCell
        if (cell == nil) {
            cell = TMSPorfileTableCell.init(style: .default, reuseIdentifier: TMSPorfileTableCell.className)
        }
        
        let model:TMSMineModel = dataSource[indexPath.row];
        cell?.mb_config(withItemModel: model)
        cell?.longPressBlock = {[weak self] () in
             self?.didCickLogupload();
        }
        
        return cell!
    }
}

extension TMSPorfileVC : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
    
