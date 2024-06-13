//
//  MBChaosCrashIssue.swift
//  MBAPMDebug
//
//  Created by xp on 2022/5/6.
//

import Foundation

@objc
public class MBChaosCrashIssue: NSObject, MBChaosIssueProtocol {
    
    public func triggerIssue() {
        
        let numbers = [1, 2, 3, 4, 5]
        print(numbers[5])
    }
}
