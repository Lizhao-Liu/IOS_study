//
//  TMSMineTableViewCell.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/10.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation

@objc public class TMSMineTableViewCell: MBBaseTableViewCell {
    
    public override class func mb_createCell(for tableView: UITableView!) -> Self {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TMSMineTableViewCell")
        if cell == nil {
            cell = TMSMineTableViewCell.init(style: .default, reuseIdentifier: "TMSMineTableViewCell")
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
        self.backgroundColor = UIColor.white;
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(arrowImgView)
        contentView.addSubview(line)

        titleLabel.mas_makeConstraints { make in
            guard let make = make else {  return }
            make.left.mas_equalTo()(MBFit(a:16))
            make.centerY.mas_equalTo()(self.mas_centerY);
            make.right.mas_lessThanOrEqualTo()(self.subTitleLabel.mas_left);
        }
        
        subTitleLabel.mas_makeConstraints { make in
            make?.centerY.mas_equalTo()(self.mas_centerY);
            make?.right.mas_lessThanOrEqualTo()(self.arrowImgView.mas_left)?.offset()(-5);
        }
        
        arrowImgView.mas_makeConstraints { make in
            make?.centerY.mas_equalTo()(self.mas_centerY);
            make?.right.mas_equalTo()(MBFit(a:-16));
            make?.size.mas_equalTo()(MBFit(11));
        }
        
        line.mas_makeConstraints { make in
            make?.left.mas_equalTo()(self.titleLabel)
            make?.right.mas_equalTo()(self)
            make?.height.mas_equalTo()(0.5)
            make?.bottom.mas_equalTo()(-0.5)
        }
        
    }
    
    public override func mb_config(withItemModel itemModel: Any!) {
        guard itemModel is TMSMineModel else {
            return
        }
        let tempItem = itemModel as! TMSMineModel
        titleLabel.text = !tempItem.title.isEmpty ? tempItem.title : ""
        subTitleLabel.text = !tempItem.content.isEmpty ? tempItem.content : ""
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
        subTitleLabel.textColor = UIColor.color_999999()
        subTitleLabel.textAlignment = .right;
        subTitleLabel.numberOfLines = 0;
        return subTitleLabel
    }()
    
    private lazy var arrowImgView: UIImageView = {
        let arrowImgView = UIImageView()
        arrowImgView.image = UIImage.img(fromBundle: "TMSBaseModule", withNamed: "tms_rightarrow")
        return arrowImgView
    }()
    
    @objc public lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init("#E8E8E8");
        return line
    }()
    
}


