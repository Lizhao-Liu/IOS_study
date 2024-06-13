//
//  TMSLoginVerfiyCodeTextField.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/28.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation
import UIKit
import Lottie

public class TMSLoginVerfiyCodeTextField: TMSNewBaseView {
    
    public var timeCount : Int?
    public var timer : Timer?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        tms_createUI()
        tms_createLayout()
        
        self.configUI()
    }
    
    public override func tms_createUI() {
        self.addSubview(inputTextField)
        self.addSubview(lineView)
        self.addSubview(verifyCodeBtn)

        self.updateLineViewBgColorWithState(focused: false)
        self.updateCodeBtnColorWithState(cantouch: false)
    }

    public override func tms_createLayout() {
        lineView.mas_makeConstraints { make in
            make?.left.right().bottom().mas_equalTo()(self)
            make?.height.mas_equalTo()(1.0/UIScreen.main.scale)
        }
        
        verifyCodeBtn.mas_makeConstraints { make in
            make?.right.mas_equalTo()(self.lineView)
            make?.bottom.mas_equalTo()(self.lineView.mas_top)?.offset()(MBFit(a: -8))
            make?.size.mas_equalTo()(CGSize(width: MBFit(a: 105), height: MBFit(a: 30)))
        }
            
        inputTextField.mas_makeConstraints { make in
            make?.top.mas_equalTo()(MBFit(a: 12))
            make?.left.mas_equalTo()(MBFit(a: 9.5))
            make?.right.mas_equalTo()(self.verifyCodeBtn.mas_left)?.offset()(MBFit(a: -15))
            make?.bottom.mas_equalTo()(self.lineView.mas_top)?.offset()(MBFit(a: -12))
        }
    }
    
    public func configUI() {
        
        let tms_timecout = UserDefaults.standard.integer(forKey: "tms_timecout")
        let oldDate: NSDate? = UserDefaults.standard.object(forKey: "tms_timecout_date") as? NSDate ?? nil

        //时间倒计时等于0，或者缓存日期不存在
        guard let temDate = oldDate else {
            self.stopTimer()
            return
        }

        if (tms_timecout == 0) {
            self.stopTimer()
            return
        }

        let newDate: NSDate = NSDate.init()
        let timefly = newDate.second - temDate.second

        //超过一分钟就没有继续倒计时的必要了

        let ti : TimeInterval = newDate.timeIntervalSince(temDate as Date)
        let minutes: Int  = Int((ti / 60))
        if (minutes > 0) {
            self.stopTimer()
            return;
        }

        //中断时间超过倒计时也没有继续倒计时的必要了
        if (tms_timecout - timefly <= 0) {
            self.stopTimer()
            return;
        }

        self.startTimerWithCount(count: tms_timecout - timefly)
    }
    
    // MARK - Timer Action --
    public func startTimer() {
        self.startTimerWithCount(count: 60)
    }
    public func startTimerWithCount(count:Int) {
        self.timeCount = count
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(makeAction), userInfo: nil, repeats: true)
        self.timer?.fire()
        self.updateCodeBtnColorWithState(cantouch: false)
    }

    @objc public func makeAction() {
        self.timeCount = self.timeCount! - 1
        
        if(self.timeCount == 0) {
            self.verifyCodeBtn.setTitle("重新获取", for: .normal)
            self.updateCodeBtnColorWithState(cantouch: true)
            self.stopTimer()
            return
        }
        
        let codeTtile = "重新获取(\(self.timeCount ?? 0)s)"
        self.verifyCodeBtn.setTitle(codeTtile, for: .normal)
        
        //每次记录倒计时，便于在倒计时被中断之后，书接上回，继续倒计时
        UserDefaults.standard.set(self.timeCount, forKey: "tms_timecout")
        UserDefaults.standard.set(NSDate.init(), forKey: "tms_timecout_date")
        UserDefaults.standard.synchronize()
    }

    public func stopTimer() {
        if let temTimer = self.timer {
            temTimer.invalidate()
        }
        self.timer = nil
        
        UserDefaults.standard.removeObject(forKey: "tms_timecout")
        UserDefaults.standard.removeObject(forKey: "tms_timecout_date")
        UserDefaults.standard.synchronize()
    }

    public func isNumber(number: String)->Bool {
        let pattern = "[0-9]+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if predicate.evaluate(with: number) {
            return true
        }
        return false
    }
    
    
    public func updateLineViewBgColorWithState(focused: Bool) {
        self.lineView.backgroundColor = focused ? UIColor.init(hexString: "4885FF"): UIColor.init(hexString: "979797")
    }

    public func updateCodeBtnColorWithState(cantouch: Bool) {
        if self.timer == nil {
            return
        }
    
        let btnColor :UIColor = cantouch ? UIColor.init(hexString: "4885FF"): UIColor.init(hexString: "CCCCCC")
        verifyCodeBtn.setTitleColor(btnColor, for: .normal)
        verifyCodeBtn.layer.borderColor = btnColor.cgColor

        verifyCodeBtn.isUserInteractionEnabled = cantouch
    }
    
    //计算属性
    var _codeLength: Int? = 0
    var codeLength: Int? {
        set {
            _codeLength = newValue
            
            print("newValuenewValuenewValue:\(String(describing: newValue))")
            UserDefaults.standard.set(newValue, forKey: "tms_codelength")
            UserDefaults.standard.synchronize()
        }
        
        get {
            if _codeLength == 0 {
                let tms_codelength:Int = UserDefaults.standard.integer(forKey: "tms_codelength")
                if (tms_codelength > 0) {
                    _codeLength = tms_codelength
                } else{
                    _codeLength = 6
                }
            }
            return  _codeLength
        }
    }

    
    // MARK -- lazyInit --    
    public lazy var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.font = UIFont.systemFont(ofSize: MBFit(a:16) )
        inputTextField.textColor = UIColor.color_333333()
        inputTextField.textAlignment = .left
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.keyboardType = .numberPad
        inputTextField.isUserInteractionEnabled = true
        inputTextField.placeholder = "请输入验证码"
        inputTextField.delegate = self
        return inputTextField
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        return lineView
    }()
    
    public lazy var verifyCodeBtn: UIButton = {
        let verifyCodeBtn = UIButton.init(type: .custom)
        verifyCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: MBFit(a: 14))
        verifyCodeBtn.titleLabel?.textAlignment = .center
        verifyCodeBtn.setTitleColor(UIColor.init(hexString: "#4885FF"), for: .normal)
        verifyCodeBtn.setTitle("获取验证码", for: .normal)
        verifyCodeBtn.layer.masksToBounds = true
        verifyCodeBtn.layer.cornerRadius = MBFit(a: 15)
        
        verifyCodeBtn.layer.borderWidth = 0.5
        verifyCodeBtn.layer.borderColor = UIColor.init(hexString: "#4885FF").cgColor
        return verifyCodeBtn
    }()
    
}


extension TMSLoginVerfiyCodeTextField : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateLineViewBgColorWithState(focused: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateLineViewBgColorWithState(focused: false)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        if let length = self.codeLength, range.location >= length {
            return false
        }
                
        if  string.count > 0 && !self.isNumber(number: string) {
            return false
        }
        
        return true
    }

}
