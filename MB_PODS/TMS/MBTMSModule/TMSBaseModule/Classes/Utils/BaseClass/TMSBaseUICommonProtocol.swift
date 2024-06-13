//
//  TMSBaseUICommonProtocol.swift
//  TMSBaseModule
//
//  Created by ymm_lzz on 2022/6/22.
//

import Foundation

@objc
protocol TMSBaseUICommonProtocol {
    
    @objc optional func tms_createUI()
    @objc optional func tms_createLayout()
    
}
