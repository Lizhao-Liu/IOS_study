// 
//  NumberFormatterExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

private let numberObjectMap = ["true": NSNumber(true),
                                   "yes": NSNumber(true),
                                   "false": NSNumber(false),
                                   "no": NSNumber(false),
                                   "nil": NSNull(),
                                   "null": NSNull(),
                                   "<null>": NSNull()
]

@objc
public extension NSNumber {

    func mb_formatToSince1970Date() -> NSDate? {
        NSDate.init(timeIntervalSince1970: TimeInterval(self.int64Value/1000))
    }

    func mb_formatCentToYuan2() -> NSString {
        NSString.init(format: "%.2f", Float(abs(self.int64Value))/Float(100))
    }

    func mb_formatCentToYuanMax2() -> NSString {
        let discount = abs(self.int64Value)
        let remainder1 = Int(discount)%Int(100)
        if remainder1 > 0 {
            let remainder2 = remainder1%10
            if remainder2 > 0 {
                return NSString.init(format: "%.2f", Float(discount)/Float(100))
            } else {
                return NSString.init(format: "%.1f", Float(discount)/Float(100))
            }
        } else {
            return NSString.init(format: "%lld", Int(discount)/Int(100))
        }
    }

    func mb_formatCentToYuanWithCN() -> NSString {
        let string = mb_formatCentToYuanMax2()
        return NSString.init(format: "%@ %@", self.int64Value>=0 ? "¥" : "-¥", string)
    }

    func mb_numberWithString(_ string: NSString?) -> NSNumber? {
        guard let str = string?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
            return nil
        }
        if str.isEmpty {
            return nil
        }

        let object = numberObjectMap[str]

        if object != nil {
            if object is NSNull {
                return nil
            }
            return object as? NSNumber
        }

        // hex
        var sign = 0
        if str.hasPrefix("0x") {
            sign = 1
        } else if str.hasPrefix("-0x") {
            sign = -1
        }
        if sign != 0 {
            let scan = Scanner(string: str)
            var num: UInt64 = 1
            let success = scan.scanHexInt64(&num) && scan.isAtEnd
            return success ? NSNumber(value: Int64(num)*Int64(sign)) : nil
        }

        // normal number
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.number(from: str)
    }

}
