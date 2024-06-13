//
//  TMSPorfileTableCell.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/10.
//

import Foundation
import UIKit
import Masonry
import MBUIKit;
import SDWebImage;
import MBFoundation;

public typealias LongPressBlock = (() -> Void)


class TMSPorfileTableCell: MBBaseTableViewCell {
    
    var longPressBlock : LongPressBlock?

    override class func mb_createCell(for tableView: UITableView!) -> Self {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TMSPorfileTableCell")
        if cell == nil {
            cell = TMSPorfileTableCell.init(style: .default, reuseIdentifier: "TMSPorfileTableCell")
        }
        return cell as! Self
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.mb_separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        selectionStyle = .none
        setupItemUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupItemUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(headerImgView)
        contentView.addSubview(arrowImgView)

        self.titleLabel.mas_makeConstraints { make in
            guard let make = make else {  return }
            make.left.mas_equalTo()(MBFit(a:16))
            make.centerY.mas_equalTo()(self.mas_centerY);
        }
        
        self.subTitleLabel.mas_makeConstraints { make in
            make?.left.mas_equalTo()(self.titleLabel.mas_right)?.offset()(80);
            make?.right.mas_equalTo()(MBFit(a:-16));
            make?.centerY.mas_equalTo()(self.mas_centerY);
            make?.top.mas_equalTo()(MBFit(a:8))
            make?.bottom.mas_equalTo()(MBFit(a:-8));
        }
        
        self.headerImgView.mas_makeConstraints { make in
            make?.centerY.mas_equalTo()(self.mas_centerY);
            make?.right.mas_equalTo()(MBFit(a:-16));
            make?.size.mas_equalTo()(MBFit(a:32));
        }
        
        self.arrowImgView.mas_makeConstraints { make in
            make?.centerY.mas_equalTo()(self.mas_centerY);
            make?.right.mas_equalTo()(MBFit(a:-16));
            make?.size.mas_equalTo()(MBFit(a:11));
        }
        
        let longTap:UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(didCickLongPressView))
        longTap.minimumPressDuration = 2;
        self.addGestureRecognizer(longTap)
        
    }
    
    @objc private func didCickLongPressView(sender:UILongPressGestureRecognizer) {
        if (sender.state == .ended) {
            longPressBlock?()
        }
    }
    
    override func mb_config(withItemModel itemModel: Any?) {
        guard itemModel is TMSMineModel else {
            return
        }
        let tempItem = itemModel as! TMSMineModel
        titleLabel.text = tempItem.title
        
        self.headerImgView.isHidden = tempItem.type != 1;
        self.subTitleLabel.isHidden = tempItem.type != 0;
        self.arrowImgView.isHidden = tempItem.type != 2;
        
        let headerImage = (self.headerImgView.image != nil) ? self.headerImgView.image : UIImage.img(fromBundle: "TMSBaseModule", withNamed: "placeholderimg_user")
        self.headerImgView.sd_setImage(with: NSURL.init(string: tempItem.content) as URL?, placeholderImage: headerImage)
        
        let content: String? = tempItem.content
        self.subTitleLabel.text = "\(content ?? "")"
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.color_333333()
        titleLabel.text = "";
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
    
    private lazy var headerImgView: UIImageView = {
        let headerImgView = UIImageView()
        headerImgView.layer.masksToBounds = true
        headerImgView.layer.cornerRadius = MBFit(16)
        headerImgView.backgroundColor = UIColor .mb_color(withHex: 0xCCCCCC)
        return headerImgView
    }()
    
    private lazy var arrowImgView: UIImageView = {
        let arrowImgView = UIImageView()
        arrowImgView.image = UIImage.img(fromBundle: "TMSBaseModule", withNamed: "tms_rightarrow")
        return arrowImgView
    }()
    
}

