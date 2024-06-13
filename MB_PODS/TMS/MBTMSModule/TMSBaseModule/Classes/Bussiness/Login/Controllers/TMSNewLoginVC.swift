//
//  TMSNewLoginVC.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/22.
//

import Foundation
import MBCommonUILib;
import MBUIKit
import UIKit
import Masonry
import MBNetworkLib

@objc
public class TMSNewLoginVC: TMSNewBaseViewController {
    
    private let keyOfSmsModel: String = "sendSmsVerifyCode"
    private var smsModel: TMSLoginSmsModel?

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    public override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tms_createUI()
        self.tms_createLayout()
        
        self.configUI()
    }
    
    /// 配置页面
    public func configUI() {
        //设置登录按钮 - 置灰
        self.updateLoginBtnColorWithState(cantouch: true)

        //从缓存中读取手机号码的值
        self.phoneTextField.inputTextField.text = TMSUserManager.shared().userInfo?.nakedMobile;
        
        //从缓存中读取上一次获取到的验证码信息（上一次获取了验证码，然后app被杀掉了，导致验证码还没有被消费）
        if let json = UserDefaults.standard.object(forKey: self.keyOfSmsModel) {
            self.smsModel = TMSLoginSmsModel.yy_model(withJSON: json)
        }
        
    }
    
    // 点击空白处关闭键盘
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //或注销当前view(或它下属嵌入的text fields)的first responder 状态，即可关闭其子控件键盘
        self.view?.endEditing(false)
    }
    
    public override func tms_createUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(topView)
        self.view.addSubview(centerView)
        topView.addSubview(logoImgView)
        
        // center subViews
        centerView.addSubview(phoneTextField)
        centerView.addSubview(codeTextField)
        centerView.addSubview(loginBtn)
        centerView.addSubview(applyDemonstrateBtn)
        centerView.addSubview(agreeView)
        centerView.addSubview(registerBtn)
        registerBtn.addSubview(bottomLineView)
    }
    
    // 隐藏导航栏
    @objc public override func mb_isNaviBarHidden() -> Bool {
        return true;
    }
    
    public override func tms_createLayout() {
        topView.mas_makeConstraints { make in
            make?.left.right().mas_equalTo()(0)
            make?.top.mas_equalTo()(MBFit(a: 120))
            make?.height.mas_equalTo()(MBFit(a: 82))
        }
        
        logoImgView.mas_makeConstraints { make in
            make?.center.mas_equalTo()(self.topView)
            make?.size.mas_equalTo()(CGSize(width: MBFit(a: 180), height: MBFit(a: 67)))
        }
        
        centerView.mas_makeConstraints { make in
            make?.left.mas_equalTo()(MBFit(a: 32))
            make?.right.mas_equalTo()(MBFit(a: -32))
            make?.top.mas_equalTo()(self.topView.mas_bottom)?.offset()(MBFit(a: 31))
            make?.bottom.mas_equalTo()(self.registerBtn.mas_bottom)
        }
        
        // center subViews
        phoneTextField.mas_makeConstraints { make in
            make?.top.left().right().mas_equalTo()(0)
            make?.height.mas_equalTo()(MBFit(a: 47))
        }
        
        codeTextField.mas_makeConstraints { make in
            make?.left.right().mas_equalTo()(0)
            make?.top.mas_equalTo()(self.phoneTextField.mas_bottom)?.offset()(MBFit(a: 12))
            make?.height.mas_equalTo()(MBFit(a: 47))
        }
        
        loginBtn.mas_makeConstraints { make in
            make?.left.right().mas_equalTo()(0)
            make?.top.mas_equalTo()(self.codeTextField.mas_bottom)?.offset()(MBFit(a: 41))
            make?.height.mas_equalTo()(MBFit(a: 45))
        }
        
        applyDemonstrateBtn.mas_makeConstraints { make in
            make?.left.right().mas_equalTo()(0)
            make?.top.mas_equalTo()(self.loginBtn.mas_bottom)?.offset()(MBFit(a: 20))
            make?.height.mas_equalTo()(MBFit(a: 45))
        }
        
        agreeView.mas_makeConstraints { make in
            make?.left.mas_equalTo()(-7)
            make?.right.mas_equalTo()(0)
            make?.top.mas_equalTo()(self.applyDemonstrateBtn.mas_bottom)?.offset()(MBFit(a: 40))
            make?.height.mas_greaterThanOrEqualTo()(60)
        }

        registerBtn.mas_makeConstraints { make in
            make?.centerX.mas_equalTo()(0)
            make?.top.mas_equalTo()(self.agreeView.mas_bottom)?.offset()(MBFit(a: -4));
            make?.height.mas_equalTo()(MBFit(a: 21))
        }
        
        bottomLineView.mas_makeConstraints { make in
            make?.left.right().mas_equalTo()(0)
            make?.height.mas_equalTo()(1)
            make?.bottom.mas_equalTo()(MBFit(a: -2))
        }
    }
    
    //MARK ---- 登录成功 ---
    private func loginSuccess(result: TMSUserModel) {
        
        result.nakedMobile = self.phoneTextField.inputTextField.text ?? ""
        TMSUserManager.shared().updateUserInfo(with: result, cover: true)
        // 发送用户手动登录成功通知
        TMSUserManager.shared().postLoginSuccesseedNotification(withIsManualLogin: true)
        UserDefaults.standard.removeObject(forKey: self.keyOfSmsModel)
        UserDefaults.standard.synchronize()
        self.codeTextField.stopTimer()
    }

    
    
    //MARK ---- Other ---
    private func updateLoginBtnColorWithState(cantouch: Bool) {
        let btnColor: UIColor = cantouch ? UIColor.init(hexString: "#4885FF") : UIColor.init(hexString: "#CCCCCC")
        self.loginBtn.backgroundColor = btnColor;
        self.loginBtn.isUserInteractionEnabled = cantouch;
    }
    
    private func vaildPhone(phone: String) -> Bool {
        let pattern = "^1\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        if predicate.evaluate(with: phone) {
            let result = TMSUserModel()
            result.nakedMobile = phone
            return true
        }
        return false
    }
    
    private func vaildCode(code: String?) -> Bool {

        guard let temcode = code else {
            return false
        }

        // 验证码smsModel存在
        if let model = self.smsModel,model.isValid {
            return temcode.count == model.verifyCodeLength
        }
        
        if (temcode.count == self.codeTextField.codeLength) {
            // MBGTipView.showTip("验证码不正确")
        }
        
        return false
    }
    
    @objc private func didClickLoginBtn(sender:UIButton) {

        let mobile = self.phoneTextField.inputTextField.text ?? ""
        let smsCaptcha = self.codeTextField.inputTextField.text ?? ""
        let timestamp = self.smsModel?.timestamp ?? ""

        if mobile.count == 0 {
            MBGTipView.showTip("手机号不能为空")
            return
        }
        
        if !self.vaildPhone(phone:mobile) {
            MBGTipView.showTip("手机号格式不正确")
            return
        }
        
        if smsCaptcha.count == 0 {
            MBGTipView.showTip("验证码不能为空")
            return
        }
        if !self.vaildCode(code:smsCaptcha) {
            MBGTipView.showTip("验证码不正确")
            return
        }
        
        if !self.agreeView.protocolAgreeButton.isSelected {
            MBGTipView.showTip("请同意相关协议")
            return
        }
        
        let paramDic = [
            "mobile":mobile,
            "smsCaptcha":smsCaptcha,
            "timestamp":timestamp,
        ]
        
        self.view.tms_startLoading()
        
        TMSNetwork.post(withPath: "/yzg-saas-permission-app/yzgApp/user/smsCaptchaLogin", params: paramDic, expect: TMSUserModel.self) { [weak self] (result) in
            
            self?.view.tms_endLoading()
            guard let strongSelf = self else {
                return
            }

            guard let userModel = result as? TMSUserModel else {
                fatalError("smsCaptchaLogin back change to TMSUserModel failed")
            }
            
            strongSelf.loginSuccess(result: userModel)

        } onFailed: { error in
            let message:String? =  error.message ?? "网络请求失败"
            self.view.tms_endLoading(withTip: message!)
        }
    }
        
    @objc private func didClickVerifyCodeBtn(sender:UIButton) {
        let mobile = self.phoneTextField.inputTextField.text ?? ""
        if mobile.count == 0 {
            MBGTipView.showTip("手机号不能为空")
            return
        }
        
        if !self.vaildPhone(phone:mobile) {
            MBGTipView.showTip("手机号格式不正确")
            return
        }
        
        let paramDic = [
            "mobile":mobile,
            "scene":"1003"
        ]
        
        self.view.tms_startLoading()
        
        TMSNetwork.post(withPath: "/yzg-saas-permission-app/yzgApp/user/sendSmsVerifyCode", params: paramDic, expect: TMSLoginSmsModel.self) { [weak self] (result) in
            
            self?.view.tms_endLoading(withTip: "短信验证码已发送至手机，请注意查收")
            guard let strongSelf = self else {
                return
            }

            guard let smsModel = result as? TMSLoginSmsModel else {
                fatalError("smsCaptchaLogin back change to TMSUserModel failed")
            }
            
            strongSelf.smsModel = smsModel
            
            UserDefaults.standard.set(strongSelf.smsModel?.yy_modelToJSONString(), forKey: strongSelf.keyOfSmsModel)
            UserDefaults.standard.synchronize()
            
            strongSelf.codeTextField.codeLength = strongSelf.smsModel?.verifyCodeLength ?? 6
            strongSelf.codeTextField.startTimer()
            
            strongSelf.codeTextField.inputTextField.text = ""

        } onFailed: { error in
            if error.code == 210030 {
                self.view.tms_endLoading()
                return
            }
            let message:String? =  error.message ?? "网络请求失败"
            self.view.tms_endLoading(withTip: message!)
        }
    }
    
    @objc private func didClickApplyDemo(sender:UIButton) {

        TMSRouterCenter.tms_performWithURLString(kYMMUserModuleSchemaApplyViewDemo, params: nil)
    }

    @objc private func didClickRegisterBtn(sender:UIButton) {
        let alert = MBGAlertView.tipsView(withTitle: TMSMSG_TIPTITLE, message: "暂不支持移动端注册，如需注册请移步电脑端。网址：www.tms8.com", actionButton: TMSMSG_IKNOW)
        alert?.show()
    }

    
    // MARK ------- lazy init -0-
    private lazy var topView: UIView = {
        let topView = UIView()
        return topView
    }()

    private lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.image = UIImage.img(fromBundle: "TMSBaseModule", withNamed: "login_logo")
        logoImgView.contentMode = .scaleAspectFit
        return logoImgView
    }()
    private lazy var centerView: UIView = {
        let centerView = UIView()
        return centerView
    }()
    
    private lazy var phoneTextField: TMSNewLoginTextField = {
        let phoneTextField = TMSNewLoginTextField()
        return phoneTextField
    }()
    
    private lazy var codeTextField: TMSLoginVerfiyCodeTextField = {
        let codeTextField = TMSLoginVerfiyCodeTextField()
        codeTextField.verifyCodeBtn.addTarget(self, action: #selector(didClickVerifyCodeBtn), for: .touchUpInside)
        return codeTextField
    }()

    private lazy var loginBtn: UIButton = {
        let loginBtn = UIButton.init(type: .custom)
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: MBFit(a: 16))
        loginBtn.titleLabel?.textAlignment = .center
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.addTarget(self, action: #selector(didClickLoginBtn), for: .touchUpInside)
        loginBtn.backgroundColor = UIColor.init(hexString: "#4885FF")
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = MBFit(a: 23)
        return loginBtn
    }()
    
    private lazy var applyDemonstrateBtn: UIButton = {
        let applyDemoBtn = UIButton.init(type: .custom)
        applyDemoBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: MBFit(a: 16))
        applyDemoBtn.titleLabel?.textAlignment = .center
        applyDemoBtn.setTitleColor(UIColor.init(hexString: "#4885FF"), for: .normal)
        applyDemoBtn.setTitle("新用户，预约演示", for: .normal)
        applyDemoBtn.addTarget(self, action: #selector(didClickApplyDemo), for: .touchUpInside)
        applyDemoBtn.layer.masksToBounds = true
        applyDemoBtn.layer.cornerRadius = MBFit(a: 23)
        applyDemoBtn.layer.borderWidth = MBFit(a: 1)
        applyDemoBtn.layer.borderColor = UIColor.init(hexString: "#4885FF")?.cgColor
        return applyDemoBtn
    }()
    
    private lazy var registerBtn: UIButton = {
        let registerBtn = UIButton.init(type: .custom)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: MBFit(a: 15))
        registerBtn.titleLabel?.textAlignment = .center
        registerBtn.setTitleColor(UIColor.color_666666(), for: .normal)
        registerBtn.setTitle("立即注册", for: .normal)
        registerBtn.addTarget(self, action: #selector(didClickRegisterBtn), for: .touchUpInside)
        registerBtn.backgroundColor = .clear
        registerBtn.isHidden = true
        return registerBtn
    }()

    private lazy var bottomLineView: UIView = {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.color_666666()
        bottomLineView.isUserInteractionEnabled = true;
        bottomLineView.isHidden = true
        return bottomLineView
    }()
    
    private lazy var agreeView: TMSLoginAgreeView = {
        let agreeView = TMSLoginAgreeView()
        return agreeView
    }()
    
    
}
