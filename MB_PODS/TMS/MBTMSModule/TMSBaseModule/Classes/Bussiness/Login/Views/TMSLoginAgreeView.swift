//
//  TMSLoginAgreeView.swift
//  MBTMSModule
//
//  Created by ymm_lzz on 2022/6/29.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation
import UIKit
import YYText

let kLoginProtocolAgreeButtonWidth = 30.0
let kLoginProtocolAgreeButtonEdgeImageInset = 8.0

public class TMSLoginAgreeView: TMSNewBaseView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        tms_createUI()
        tms_createLayout()
    }
    
    public override func tms_createUI() {
        self.addSubview(protocolAgreeButton)
        self.addSubview(acceptUserProtocolView)
        self.addSubview(expandControl)
    }

    public override func tms_createLayout() {

        protocolAgreeButton.mas_makeConstraints { make in
            make?.left.mas_equalTo()(self)
            make?.centerY.mas_equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: kLoginProtocolAgreeButtonWidth, height: kLoginProtocolAgreeButtonWidth))
        }

        acceptUserProtocolView.mas_makeConstraints { make in
            make?.top.mas_equalTo()(self.mas_top)?.offset()(22)
            make?.left.mas_equalTo()(self.protocolAgreeButton.mas_right)
            make?.right.mas_equalTo()(self.mas_right)
            make?.bottom.mas_equalTo()(self)
        }

        expandControl.mas_makeConstraints { make in
            make?.top.left().mas_equalTo()(self)
            make?.bottom.mas_equalTo()(self.protocolAgreeButton.mas_bottom)
            make?.width.mas_equalTo()(100)
        }
    }
    
    // MARK --- Action ---
    @objc public func actionClick(){
        self.protocolAgreeButton.isSelected = !self.protocolAgreeButton.isSelected;
    }
        
    // MARK -- lazyInit --
    public lazy var protocolAgreeButton: UIButton = {
        let protocolAgreeButton = UIButton.init(type: .custom)
        protocolAgreeButton.setImage(UIImage.img(fromBundle: "TMSBaseModule", withNamed: "pic_unselected"), for: .normal)
        protocolAgreeButton.setImage(UIImage.img(fromBundle: "TMSBaseModule", withNamed: "pic_selected_blueColor"), for: .selected)
        protocolAgreeButton.adjustsImageWhenHighlighted = false
        
        // 控制图片内边距
        protocolAgreeButton.contentEdgeInsets = UIEdgeInsets(top: kLoginProtocolAgreeButtonEdgeImageInset, left: kLoginProtocolAgreeButtonEdgeImageInset, bottom: kLoginProtocolAgreeButtonEdgeImageInset, right: kLoginProtocolAgreeButtonEdgeImageInset)
        protocolAgreeButton.imageView?.contentMode = .scaleAspectFill
        protocolAgreeButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill //水平方向拉伸
        protocolAgreeButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill  //垂直方向拉伸
        return protocolAgreeButton
    }()

    private lazy var acceptUserProtocolView: UIView = {
       let horEdgeInst = MBFit(a: 32)
        let acceptUserProtocolView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth-horEdgeInst*2 - kLoginProtocolAgreeButtonWidth + 5, height: 72)) // +5是因为勾选按钮向左偏移了5
        
        let privateText:String = kYMMUserModuleLoginAcceptUserProtocolContent
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.color_999999(),
            NSAttributedString.Key.font :UIFont.init(name: "PingFangSC-Regular", size: MBFit(a: 12))
        ]
       
        let attributedString = NSMutableAttributedString.init(string: privateText, attributes: attributes as [NSAttributedString.Key : Any])
        
        let userRange = privateText.range(of: kYMMUserModuleLoginAcceptUserProtocolUserService)
        if let userRange = userRange, let range1 = privateText.nsRange(from: userRange) {
            attributedString.yy_setTextHighlight(range1, color: UIColor.init(hexString: "#4885FF"), backgroundColor: UIColor.white) { [weak self] containerView, text,range,rect  in
                guard let self = self else { return }
                // 路由跳转
                TMSRouterCenter.tms_performWithURLString(kYMMUserModuleSchemaUserServiceProtocol, params: nil)
            }
        }

        let privateRange = privateText.range(of: kYMMUserModuleLoginAcceptUserProtocolPrivacy)
        if let privateRange = privateRange, let range2 = privateText.nsRange(from: privateRange) {
            attributedString.yy_setTextHighlight(range2, color: UIColor.init(hexString: "#4885FF"), backgroundColor: UIColor.white) { [weak self] containerView, text,range,rect  in
                guard let self = self else { return }
                // 路由跳转
                TMSRouterCenter.tms_performWithURLString(kYMMUserModuleSchemaPrivatePolicy, params: nil)
            }
        }
        
        let authRange = privateText.range(of: kYMMUserModuleLoginAcceptUserProtocolAuth)
        if let authRange = authRange, let range3 = privateText.nsRange(from: authRange) {
            attributedString.yy_setTextHighlight(range3, color: UIColor.init(hexString: "#4885FF"), backgroundColor: UIColor.white) { [weak self] containerView, text,range,rect  in
                guard let self = self else { return }
                // 路由跳转
                TMSRouterCenter.tms_performWithURLString(kYMMUserModuleSchemaPrivateAuth, params: nil)
            }
        }
        
        let yylabel = YYLabel()
        yylabel.frame = CGRect(x: 0, y: 0, width: kScreenWidth - horEdgeInst*2 - kLoginProtocolAgreeButtonWidth + 5, height: 72)
        yylabel.attributedText = attributedString
        yylabel.isUserInteractionEnabled = true
        yylabel.numberOfLines = 3
        yylabel.sizeToFit()
        acceptUserProtocolView.addSubview(yylabel)
        return acceptUserProtocolView
    }()
    
    private lazy var expandControl: UIControl = {
        let expandControl = UIControl()
        expandControl.addTarget(self, action: #selector(actionClick), for: .touchUpInside)
        return expandControl
    }()
    
}


fileprivate extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
           return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
}
