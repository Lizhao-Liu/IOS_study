//
//  MBNetworkInfoProvider.swift
//  MBFoundation
//
//  Created by 汪灏 on 2021/8/23.
//

import Foundation
import CoreTelephony.CTCarrier
import CoreTelephony.CTTelephonyNetworkInfo
import Reachability
// swiftlint:disable implicit_getter

@objc
public class MBNetworkInfoProvider: NSObject {

    @objc public static let netWorkInfo = CTTelephonyNetworkInfo()

    @objc public var carrierName: String {
        get {
            var str: String?
            let netInfo = MBNetworkInfoProvider.netWorkInfo
            let carrier = netInfo.subscriberCellularProvider
            if (carrier?.isoCountryCode != nil) && (carrier?.carrierName?.count ?? 0 > 0) {
                str = carrier?.carrierName
            }
            return str ?? "unkown"
        }
    }

    @objc public var carrierType: String {
        get {
            var carrierName: String?
            let current = MBNetworkInfoProvider.netWorkInfo
            if let mnc = current.subscriberCellularProvider?.mobileNetworkCode {
                switch Int(mnc) {
                case 0: carrierName = "China_Mobile"
                case 1: carrierName = "China_Unicom"
                case 2: carrierName = "China_Mobile"
                case 3: carrierName = "China_Telecom"
                case 5: carrierName = "China_Telecom"
                case 6: carrierName = "China_Unicom"
                case 7: carrierName = "China_Mobile"
                case 9: carrierName = "China_Unicom"
                case 11: carrierName = "China_Telecom"
                case 20: carrierName = "China_Tietong"
                default: break
                }
            }
            return carrierName?.uppercased() ?? "UNKNOWN"
        }
    }

    @objc public var networkType: String? {
        get {
            var type: String?
            let reachability = Reachability.forInternetConnection()
            let status = reachability?.currentReachabilityStatus()
            switch status {
            case .NotReachable: type = "无网络连接"
            case .ReachableVia2G: type = "2G"
            case .ReachableVia3G: type = "3G"
            case .ReachabieVia4G: type = "4G"
            case .ReachableVia3G_4G: type = "3G_4G"
            case .ReachableViaWiFi: type = "Wi-Fi"
            case .ReachableViaWWAN: type = "WWAN"
            default: break
            }
            return type ?? "unkown"
        }
    }

    @objc public var hcbNetworkTypeName: String? {
        get {
            var networkTypeName: String?
            let current = MBNetworkInfoProvider.netWorkInfo
            let network = current.currentRadioAccessTechnology
            let reachability = Reachability.forInternetConnection()
            let status = reachability?.currentReachabilityStatus()
            if status == .ReachableViaWiFi {
                networkTypeName = "Wi-Fi"
            } else if status == .NotReachable {
                networkTypeName = "NoNetWork"
            } else {
                if network == CTRadioAccessTechnologyGPRS {
                    networkTypeName = "2G"
                } else if network == CTRadioAccessTechnologyCDMA1x {
                    networkTypeName = "2G"
                } else if network == CTRadioAccessTechnologyEdge {
                    networkTypeName = "2G"
                } else if network == CTRadioAccessTechnologyWCDMA {
                    networkTypeName = "3G"
                } else if network == CTRadioAccessTechnologyHSDPA {
                    networkTypeName = "3G"
                } else if network == CTRadioAccessTechnologyHSUPA {
                    networkTypeName = "3G"
                } else if network == CTRadioAccessTechnologyCDMAEVDORev0 {
                    networkTypeName = "3G"
                } else if network == CTRadioAccessTechnologyCDMAEVDORevA {
                    networkTypeName = "3G"
                } else if network == CTRadioAccessTechnologyCDMAEVDORevB {
                    networkTypeName = "3G"
                } else if network == CTRadioAccessTechnologyeHRPD {
                    networkTypeName = "3G"
                } else if network == CTRadioAccessTechnologyLTE {
                    networkTypeName = "4G"
                }
                if #available(iOS 14.1, *) {
                    if network == CTRadioAccessTechnologyNRNSA {
                        networkTypeName = "5G"
                    } else if network == CTRadioAccessTechnologyNR {
                        networkTypeName = "5G"
                    }
                }
            }
            return networkTypeName ?? "UNKNOWN"
        }
    }

    @objc public static func sharedNetworkInfoProvider() -> MBNetworkInfoProvider {
        return _instance
    }

    private static let _instance = MBNetworkInfoProvider()
    private override init() {
        super.init()
    }
}
