//
//  TMSWorkNewBannerView.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/16.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation
import SDCycleScrollView
import UIKit

public typealias TMSWorkBannerViewBlock = ((_ index:Int) -> Void)

@objc
public class TMSWorkNewBannerView: TMSNewBaseView {
    
    @objc public var workBannerViewBlock : TMSWorkBannerViewBlock?

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
    }
    
    private func initUI() {
        self.backgroundColor = UIColor.white;
        self.addSubview(self.bannerView)
        
    }
    
    private func initLayout() {
 
    }
        
    // MARK -- Action --
    public func updateFunctionViews(model: [String]?) {
        
        guard let imgArray = model else {
            return
        }
        
        self.bannerView.imageURLStringsGroup = imgArray;
        self.bannerView.autoScroll = imgArray.count > 1;
        
        if (imgArray.count > 0) {
            self.bannerView.makeScroll(to: 0)
        }
    }
    
    
    // MARK -- lazyInit --
    private lazy var bannerView: SDCycleScrollView! = {
        let bannerView = SDCycleScrollView.init(frame: CGRect.init(x: MBFit(16), y: 0, width: self.width-2*MBFit(16), height: self.height-16), shouldInfiniteLoop: true, imageNamesGroup: nil)
        bannerView!.backgroundColor = UIColor.white
        bannerView!.currentPageDotColor = UIColor.mb_color(withHex: 0x4885FF)
        bannerView!.pageControlStyle = SDCycleScrollViewPageContolStyle.init(SDCycleScrollViewPageContolStyleAnimated.rawValue)
        bannerView!.pageControlDotSize = CGSize(width: MBFit(8), height: MBFit(8))
        bannerView!.autoScrollTimeInterval = 3.0
        bannerView!.delegate = self
        bannerView!.showPageControl = true
        return bannerView!
    }()
    
}

extension TMSWorkNewBannerView: SDCycleScrollViewDelegate {
    
    public func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        self.workBannerViewBlock?(index)
    }
    
}
