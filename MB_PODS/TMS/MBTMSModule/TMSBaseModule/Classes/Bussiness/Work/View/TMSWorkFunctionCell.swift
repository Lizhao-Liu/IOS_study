//
//  TMSWorkFunctionCell.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/16.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation
import SDWebImage

class TMSWorkFunctionCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
    }
    
    private func initUI() {
        self.backgroundColor = UIColor.white;
        self.addSubview(self.itemImageView)
        self.addSubview(self.nameLabel)
        
    }
    
    private func initLayout() {
        itemImageView.mas_makeConstraints { make in
            guard let make = make else {  return }
            make.centerX.mas_equalTo()(self.mas_centerX);
            make.size.mas_equalTo()(CGSize(width: MBFit(67.5), height: MBFit(67.5)));
        }
        
        nameLabel.mas_makeConstraints { make in
            guard let make = make else {  return }
            make.top.mas_equalTo()(self.itemImageView.mas_bottom)?.offset()(MBFit(-10))
            make.left.mas_equalTo()(MBFit(8))
            make.right.mas_equalTo()(MBFit(-8))
            make.height.mas_equalTo()(MBFit(20));
        }
        
    }
    
    
    // MARK -- Action --
    public func bindData(itemModel: TMSWorkFunctionModel?) {
        guard let itemModel = itemModel else {
            return
        }
        
        self.nameLabel.text = itemModel.name
        self.itemImageView.sd_setImage(with: NSURL.init(string: itemModel.icon) as URL?, completed: nil)
    }
    
    // MARK -- lazyInit --
    private lazy var itemImageView: UIImageView = {
        let headerImgView = UIImageView()
        return headerImgView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: MBFit(16))
        nameLabel.textColor = UIColor.color_333333()
        nameLabel.textAlignment = .center;
        nameLabel.numberOfLines = 0;
        return nameLabel
    }()
        
}
