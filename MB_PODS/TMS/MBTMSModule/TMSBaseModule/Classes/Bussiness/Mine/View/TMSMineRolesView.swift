//
//  TMSMineRolesView.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/9.
//

import Foundation
import UIKit
import YYText;
import Masonry
import MBUIKit
import MBFoundation

class TMSMineRolesView: UIView {
    
    var longPressBlock : LongPressBlock?

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItemUI()
    }
    
    private func setupItemUI() {
        self.backgroundColor = UIColor.white;
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)

        self.titleLabel.mas_makeConstraints { make in
            guard let make = make else {  return }
            make.left.mas_equalTo()(MBFit(a:16))
            make.centerY.mas_equalTo()(self.mas_centerY);
        }
        
        self.subTitleLabel.mas_makeConstraints { make in
            make?.left.mas_equalTo()(self.titleLabel.mas_right)?.offset()(80);
            make?.right.mas_equalTo()(MBFit(a:-16));
            make?.centerY.mas_equalTo()(self.mas_centerY);
            make?.top.mas_equalTo()(MBFit(a:14))
            make?.bottom.mas_equalTo()(MBFit(-14));
        }
        
        let longTap:UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(didCickLongPressView))
        longTap.minimumPressDuration = 3;
        self.addGestureRecognizer(longTap)
    }
    
    // MARK -- Action --
    /// 崩溃note：对字符串一定要判空
    @objc public func setUpWithRoleName(roleName: String?) {
        
        let temRoleName:String = roleName ?? ""
        let introText = NSMutableAttributedString.init(string: temRoleName)
        introText.yy_lineSpacing = 8;
        introText.yy_alignment = NSTextAlignment.right;
        self.subTitleLabel.attributedText = introText;
    }
    
    @objc private func didCickLongPressView(sender:UILongPressGestureRecognizer) {
        if (sender.state == .ended) {
            longPressBlock?()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.color_333333()
        titleLabel.text = "角色";
        return titleLabel
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textColor = UIColor.color_333333()
        subTitleLabel.textAlignment = .right;
        subTitleLabel.numberOfLines = 0;
        return subTitleLabel
    }()

}
