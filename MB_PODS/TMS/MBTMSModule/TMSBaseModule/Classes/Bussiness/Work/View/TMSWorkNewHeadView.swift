//
//  TMSWorkNewHeadView.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/16.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation
import UIKit
import SDWebImage
import MBUIKit

public typealias TMSWorkNewHeadViewTipBtnOnClickBlock = (() -> Void)


@objc
public class TMSWorkNewHeadView: TMSNewBaseView {
    @objc public var tipOnClickBlock: TMSWorkNewHeadViewTipBtnOnClickBlock?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
        updateUIViews(model: nil)
    }
    
    private func initUI() {
        self.backgroundColor = UIColor.white;
        self.addSubview(self.headerImgView)
        self.addSubview(self.nameLabel)
    }
    
    @objc private func clickTipBtn(button: UIButton) {
        MBFastClickUtil.click(withTarget: button)
        if (MBFastClickUtil.isFastClick()) {
            return
        }
        guard let tipOnClickBlock = tipOnClickBlock else { return }
        tipOnClickBlock()
    }
    
    private func initLayout() {
        let merginTop = UIApplication.shared.statusBarFrame.height + MBFit(22)
        headerImgView.mas_makeConstraints { make in
            make?.top.mas_equalTo()(merginTop);
            make?.left.mas_equalTo()(MBFit(16));
            make?.size.mas_equalTo()(MBFit(37));
        }

        nameLabel.mas_makeConstraints { make in
            guard let make = make else {  return }
            make.left.mas_equalTo()(self.headerImgView.mas_right)?.offset()(MBFit(16))
            make.right.mas_equalTo()(MBFit(-16))
            make.centerY.mas_equalTo()(self.headerImgView.mas_centerY);
        }
    }
    
    // MARK -- Action --
    public override func updateUIViews(model: AnyObject?) {
        self.headerImgView.sd_setImage(with: NSURL.init(string: TMSUserManager.shared().userInfo?.companyLogo ?? "") as URL?, placeholderImage: UIImage.img(fromBundle: "TMSBaseModule", withNamed: "placeholderimg_company"))
        self.nameLabel.text = TMSUserManager.shared().userInfo?.companyName
    }
    
    public func updateTipBtn(isShow: Bool) {
        if (isShow) {
            if (self.tipBtn.superview == nil) {
                self.addSubview(self.tipBtn)
                self.tipBtn.addTarget(self, action: #selector(clickTipBtn) , for: .touchUpInside)
            }
            self.tipBtn.mas_makeConstraints { make in
                guard let make = make else { return }
                make.right.mas_equalTo()(MBFit(-9))
                make.centerY.mas_equalTo()(self.headerImgView.mas_centerY)
                make.width.mas_equalTo()(MBFit(68))
                make.height.mas_equalTo()(MBFit(20))
            }
            self.nameLabel.mas_remakeConstraints { make in
                guard let make = make else {  return }
                make.left.mas_equalTo()(self.headerImgView.mas_right)?.offset()(MBFit(16))
                make.right.mas_equalTo()(self.tipBtn.mas_left)?.offset()(MBFit(-16))
                make.centerY.mas_equalTo()(self.headerImgView.mas_centerY);
            }
            self.layoutIfNeeded()
        } else {
            if (self.tipBtn.superview != nil) {
                self.tipBtn.removeFromSuperview()
            }
            self.nameLabel.mas_remakeConstraints { make in
                guard let make = make else {  return }
                make.left.mas_equalTo()(self.headerImgView.mas_right)?.offset()(MBFit(16))
                make.right.mas_equalTo()(MBFit(-16))
                make.centerY.mas_equalTo()(self.headerImgView.mas_centerY);
            }
            self.layoutIfNeeded()
        }
    }
    
    
    // MARK -- lazyInit --
    private lazy var headerImgView: UIImageView = {
        let headerImgView = UIImageView()
        headerImgView.backgroundColor = UIColor.white
        headerImgView.layer.masksToBounds = true
        headerImgView.layer.cornerRadius = MBFit(19)
        return headerImgView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.color_333333()
        nameLabel.numberOfLines = 0;
        return nameLabel
    }()
    
    private lazy var tipBtn: UIButton = {
        
        let tipBtn = UIButton(type: .custom)
        tipBtn.backgroundColor = UIColor.init(hexString: "#FFEBEB")
        tipBtn.setTitle("即将到期", for: .normal)
        tipBtn.layer.masksToBounds = true
        tipBtn.layer.cornerRadius = MBFit(a: 2)
        tipBtn.setTitleColor(UIColor.init(hexString: "#FF3333"), for: .normal)
        tipBtn.titleLabel?.textAlignment = .center
        let tipTextFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        tipBtn.titleLabel?.font = tipTextFont
        return tipBtn
    }()
    
}
