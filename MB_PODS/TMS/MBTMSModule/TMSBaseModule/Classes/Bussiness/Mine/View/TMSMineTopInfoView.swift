//
//  TMSMineTopInfoView.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/15.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation
import UIKit
import SDWebImage

//屏宽
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kSafeAreaBottomHeight = kScreenHeight >= 812 ? 34 : 0

class TMSMineTopInfoView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
    }
    
    
    private func initUI() {
        self.backgroundColor = UIColor.white;
        self.addSubview(headerImgView)
        self.addSubview(nameLabel)
        self.addSubview(rolesContainerView)
        self.addSubview(phoneLabel)
        self.addSubview(arrowImgView)
    }
    
    private func initLayout() {
        
        headerImgView.mas_makeConstraints { make in
            make?.top.mas_equalTo()(MBFit(a: 20));
            make?.left.mas_equalTo()(MBFit(a:16));
            make?.size.mas_equalTo()(MBFit(50));
            make?.bottom.mas_equalTo()(MBFit(a:-20));
        }
        
        nameLabel.mas_makeConstraints { make in
            guard let make = make else {  return }
            make.left.mas_equalTo()(self.headerImgView.mas_right)?.offset()(MBFit(a:16))
            make.top.mas_equalTo()(self.headerImgView)?.offset()(MBFit(a: 5));
            make.height.mas_equalTo()(MBFit(a:23));
        }
        
        rolesContainerView.mas_makeConstraints { make in
            make?.left.mas_equalTo()(self.nameLabel.mas_left)
            make?.top.mas_equalTo()(self.nameLabel.mas_bottom)
            make?.right.mas_equalTo()(MBFit(a:-15));
            make?.height.mas_equalTo()(MBFit(a:15));
        }
        
        phoneLabel.mas_makeConstraints { make in
            make?.left.mas_equalTo()(self.nameLabel.mas_left)
            make?.top.mas_equalTo()(self.rolesContainerView.mas_bottom)?.offset()(3);
        }
        
        arrowImgView.mas_makeConstraints { make in
            make?.centerY.mas_equalTo()(self.mas_centerY);
            make?.right.mas_equalTo()(MBFit(a:-16));
            make?.size.mas_equalTo()(MBFit(11));
        }
        
    }
    
    func widthWithString(aString :String?) -> CGSize {
    
        guard let targetString = aString else { return CGSize(width:0,height:0)}
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let text = targetString as NSString
        let rect = text.boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: MBFit(11))], context: nil).size
        return rect
    }
    
    // MARK -- Action --
    @objc public func mb_config(withItemModel itemModel: TMSUserModel?) {
        guard let userModel = itemModel else {
            return
        }
        rolesContainerView.removeAllSubviews()
        
        let headerImage = (self.headerImgView.image != nil) ? self.headerImgView.image : UIImage.img(fromBundle: "TMSBaseModule", withNamed: "placeholderimg_user")
        self.headerImgView.sd_setImage(with: NSURL.init(string: userModel.avatar) as URL?, placeholderImage: headerImage)
        
        nameLabel.text = userModel.name
        phoneLabel.text = userModel.mobile
        
        let roles = TMSUserManager.shared().userInfo?.roles ?? []
        if roles.count > 0 {
            var tempLabel:UILabel?;
            let rolesWidth:CGFloat = kScreenWidth - 2*MBFit(16) - MBFit(50) - 30;

            for role in roles {
                var roleName = role.roleName
                let size:CGSize = self.widthWithString(aString: roleName);
                var width:CGFloat = size.width + 2*MBFit(3) + 1;
                if (width > 85) {
                    width = 85;
                }
                
                // rolesView 右边 > roles 容器的width 不再继续展示
                let rolesRight:CGFloat = tempLabel?.right ?? 0 + width;
                if (rolesRight > rolesWidth) {
                    roleName = "...";
                    width = 15;
                }
                
                let roleLabel = self.factoryRoleLabel()
                roleLabel.text = roleName;
                rolesContainerView.addSubview(roleLabel)
                
                if let label = tempLabel {
                    roleLabel.frame = CGRect(x: label.right + 3, y: 0, width: width, height: MBFit(16));
                } else {
                    roleLabel.frame = CGRect(x: 0, y: 0, width: width, height: MBFit(16));
                }
                tempLabel = roleLabel;
                
                if (rolesRight > rolesWidth) {
                    break;
                }
            }
            
        }

    }
    
    
    // MARK -- lazyInit --
    private lazy var headerImgView: UIImageView = {
        let headerImgView = UIImageView()
        headerImgView.layer.masksToBounds = true
        headerImgView.layer.cornerRadius = MBFit(25)
        headerImgView.backgroundColor = UIColor .mb_color(withHex: 0xCCCCCC)
        return headerImgView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.color_333333()
        return nameLabel
    }()
    
    private lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.textColor = UIColor.color_333333()
        return phoneLabel
    }()
    
    private lazy var rolesContainerView: UIView = {
        let rolesContainerView = UIView()
        return rolesContainerView
    }()
    
    
    private func factoryRoleLabel()-> UILabel {
        let factoryRoleLabel = UILabel()
        factoryRoleLabel.font = UIFont.systemFont(ofSize: 11)
        factoryRoleLabel.textColor = UIColor.init(hexString: "#4885FF")
        factoryRoleLabel.textAlignment = .center
        factoryRoleLabel.lineBreakMode = .byTruncatingTail
        factoryRoleLabel.layer.masksToBounds = true
        factoryRoleLabel.layer.cornerRadius = 3
        factoryRoleLabel.layer.borderWidth = 0.5
        factoryRoleLabel.layer.borderColor = UIColor.init(hexString: "#4885FF")?.cgColor
        return factoryRoleLabel
    }

    private lazy var arrowImgView: UIImageView = {
        let arrowImgView = UIImageView()
        arrowImgView.image = UIImage.img(fromBundle: "TMSBaseModule", withNamed: "tms_rightarrow")
        return arrowImgView
    }()
    
    
}
