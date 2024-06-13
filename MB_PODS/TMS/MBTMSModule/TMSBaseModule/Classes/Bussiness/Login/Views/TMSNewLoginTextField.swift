//
//  TMSNewLoginTextField.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/23.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation
import UIKit
import Lottie

@objc
public class TMSNewLoginTextField: TMSNewBaseView {
    
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
    }
    
    public override func tms_createUI() {
        self.addSubview(inputTextField)
        self.addSubview(lineView)

        self.updateLineViewBgColorWithState(focused: false)
    }
    
    public override func tms_createLayout() {
        lineView.mas_makeConstraints { make in
            make?.left.right().bottom().mas_equalTo()(self)
            make?.height.mas_equalTo()(1.0/UIScreen.main.scale)
        }
            
        inputTextField.mas_makeConstraints { make in
            make?.top.mas_equalTo()(MBFit(a: 12))
            make?.left.mas_equalTo()(MBFit(a: 9.5))
            make?.right.mas_equalTo()(MBFit(a: -9.5))
            make?.bottom.mas_equalTo()(self.lineView.mas_top)?.offset()(MBFit(a: -12))
        }
    }

    @objc public func isNumber(number: String)->Bool {
        let pattern = "[0-9]+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if predicate.evaluate(with: number) {
            return true
        }
        return false
    }
    
    
    @objc public func updateLineViewBgColorWithState(focused: Bool) {
        self.lineView.backgroundColor = focused ? UIColor.init(hexString: "4885FF"): UIColor.init(hexString: "979797")
    }

    
    // MARK -- lazyInit --
    @objc public lazy var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.font = UIFont.systemFont(ofSize: MBFit(a:16) )
        inputTextField.textColor = UIColor.color_333333()
        inputTextField.textAlignment = .left
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.keyboardType = .numberPad
        inputTextField.isUserInteractionEnabled = true
        inputTextField.placeholder = "请输入手机号"
        inputTextField.delegate = self
                
        return inputTextField
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        return lineView
    }()
    
}


extension TMSNewLoginTextField : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateLineViewBgColorWithState(focused: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateLineViewBgColorWithState(focused: false)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        if (range.location > 10) {
            return false
        }
                
        if  string.count > 0 && !self.isNumber(number: string) {
            return false
        }
        
        return true
    }

}
