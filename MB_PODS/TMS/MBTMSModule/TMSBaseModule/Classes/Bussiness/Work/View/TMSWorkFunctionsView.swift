//
//  TMSWorkFunctionsView.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/16.
//

import Foundation
import Masonry
import MBUIKit
import MBFoundation
import UIKit

public typealias TMSWorkFunctionViewBlock = ((_ indexPath:IndexPath) -> Void)

@objc
public class TMSWorkFunctionsView: TMSNewBaseView {
    private var functionArr =  [TMSWorkFunctionModel]()

    @objc public var workFunctionsViewBlock : TMSWorkFunctionViewBlock?

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
        self.addSubview(self.collectionView)
        
    }
    
    private func initLayout() {

    }
    
    
    // MARK -- 更新数据 --
    public func updateFunctionViews(model: [TMSWorkFunctionModel]?) {
        
        guard let functionArray = model else {
            return
        }
        
        self.functionArr = functionArray        
        self.collectionView.reloadData()
    }
    
    
    // MARK -- lazyInit --
    private lazy var collectionView: UICollectionView = {
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = lineSpaceOfItems
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: widthOfItem, height: heightOfItem)
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: MBFit(12), y: 0, width: self.width-2*MBFit(12), height: self.height), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.register(TMSWorkFunctionCell.classForCoder(), forCellWithReuseIdentifier: TMSWorkFunctionCell.className)
        return collectionView
    }()
    
    private func totalHeight(functionArr:[TMSWorkFunctionModel]) -> CGFloat {
        
        let rowCount:CGFloat = CGFloat( (functionArr.count / itemCount) + (functionArr.count % itemCount == 0 ? 0 : 1) )
        
        return rowCount * heightOfItem + (rowCount - 1) * lineSpaceOfItems + bottomOfCollectionView
        
    }
    
    private var heightOfItem: CGFloat {
        return MBFit(20 + 4.5 + 67.5)
    }
    
    private var widthOfItem: CGFloat {
        let itemWidth = (kScreenWidth - marginOfFunctionView*2) / CGFloat(itemCount) - 1
        return ceil(itemWidth);
    }
    private var lineSpaceOfItems: CGFloat {
        return MBFit(2)
    }
    private var bottomOfCollectionView: CGFloat {
        return MBFit(28)
    }
    
    private var marginOfFunctionView: CGFloat {
        return MBFit(12)
    }
    private var itemCount: Int {
        return 4
    }
}

extension TMSWorkFunctionsView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.functionArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMSWorkFunctionCell.className, for: indexPath) as? TMSWorkFunctionCell  else {
            fatalError("unexpected cell in collection view")
        }
        
        let model:TMSWorkFunctionModel = self.functionArr[indexPath.row]
        cell.bindData(itemModel: model)
        
        return cell
    }
    
}

extension TMSWorkFunctionsView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.workFunctionsViewBlock?(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
