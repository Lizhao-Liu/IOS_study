//
//  CrashMonitorConfigViewController.swift
//  MBAPMDebug
//
//  Created by xp on 2022/12/27.
//

import UIKit
import MBLogLib
import MBAPMLib
import MBStorageLib


class CrashMonitorConfigViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MBAPMDebugSwitchCellDelegate{
    
    
    private static let MBAPMDebugEntrySwitchCellID: String = "MBAPMEntrySwitchCellID"
    private static let MBAPMDebugZombieTraceDeallocStateStorageKey: String = "MBAPMDebugZombieTraceDeallocState"


  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "崩溃监控设置"
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.tertiarySystemBackground
        } else {
            self.view.backgroundColor = UIColor.white
        }
        self.view .addSubview(settingListView)
    }
   
    fileprivate lazy var settingListView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = UIColor.tertiarySystemBackground
        } else {
            collectionView.backgroundColor = UIColor.white
        }
        collectionView.register(MBAPMDebugSwitchCell.self, forCellWithReuseIdentifier: CrashMonitorConfigViewController.MBAPMDebugEntrySwitchCellID)
        return collectionView
    }()
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 100)
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MBAPMDebugSwitchCell = collectionView.dequeueReusableCell(withReuseIdentifier: CrashMonitorConfigViewController.MBAPMDebugEntrySwitchCellID, for: indexPath) as! MBAPMDebugSwitchCell
        cell.setLabelText("ZombieMonitor Dealloc Stack")
        
        let switchState: Bool = MBAPMZombieSniffer .traceDeallocStackEnabled()
        cell.setSwitchState(switchState)
        cell.delegate = self
        return cell;
    }
    
    
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: MBAPMDebugSwitchCellDelegate
    func switchChanged(_ isON: Bool, cellTag tag: Int) {
        MBAPMZombieSniffer.enableTraceDeallocStack(isON)
        MBStorageManager.mbkv().set(isON, forKey: CrashMonitorConfigViewController.MBAPMDebugZombieTraceDeallocStateStorageKey)
    }
}
