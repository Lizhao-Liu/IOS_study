//
//  CTTelephone.swift
//  MBFoundation
//
//  Created by rensihao on 2021/2/6.
//
//  Note20220314: 后续需要迁移，这里有使用过期API

 import Foundation
 import CoreTelephony

// swiftlint:disable line_length

@available(iOSApplicationExtension, unavailable, message: "MBCoreTelephony class is NS_EXTENSION_UNAVAILABLE.")
@objc
public class MBCoreTelephony: NSObject {
    @objc
    public static func call(with telephoneNumber: String, durationClosure: (() -> TimeInterval)?) {
        let telephoneString = "telprompt://\(telephoneNumber)".replacingOccurrences(of: "-", with: "")

        guard let telephoneURL = URL(string: telephoneString) else {
            return
        }

        guard UIApplication.shared.canOpenURL(telephoneURL) else {
            return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(telephoneURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(telephoneURL)
        }
    }

 }
