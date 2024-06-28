// 
//  StringExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

// swiftlint:disable all
internal extension MBFoundationWrapper where T == String {

    func nsRange(from range: Range<String.Index>?) -> NSRange? {
        guard let range = range else { return nil }
        if let from = range.lowerBound.samePosition(in: this.utf16), let to = range.upperBound.samePosition(in: this.utf16) {
            return NSRange(location: this.utf16.distance(from: this.utf16.startIndex, to: from), length: this.utf16.distance(from: from, to: to))
        }
        return nil
    }

    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = this.utf16.index(this.utf16.startIndex, offsetBy: nsRange.location, limitedBy: this.utf16.endIndex),
            let to16 = this.utf16.index(this.utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: this.utf16.endIndex),
            let from = from16.samePosition(in: this),
            let to = to16.samePosition(in: this)
            else { return nil }
        return from ..< to
    }

    subscript(of index: Int) -> String {
        if index < 0 || index >= this.count {
            return ""
        }
        for (i, item) in this.enumerated() {
            if index == i {
                return "\(item)"
            }
        }
        return ""
    }

    /// a[1...3]
    subscript(r: ClosedRange<Int>) -> String {
        let start = this.index(this.startIndex, offsetBy: max(r.lowerBound, 0))
        let end = this.index(this.startIndex, offsetBy: min(r.upperBound, this.count - 1))
        return String(this[start...end])
    }

    /// a[0..<2]
    subscript(r: Range<Int>) -> String {
        let start = this.index(this.startIndex, offsetBy: max(r.lowerBound, 0))
        let end = this.index(this.startIndex, offsetBy: min(r.upperBound, this.count))
        return String(this[start..<end])
    }

    /// a[...2]
    subscript(r: PartialRangeThrough<Int>) -> String {
        let end = this.index(this.startIndex, offsetBy: min(r.upperBound, this.count - 1))
        return String(this[this.startIndex...end])
    }

    /// a[0...]
    subscript(r: PartialRangeFrom<Int>) -> String {
        let start = this.index(this.startIndex, offsetBy: max(r.lowerBound, 0))
        let end = this.index(this.startIndex, offsetBy: this.count - 1)
        return String(this[start...end])
    }

    /// a[..<3]
    subscript(r: PartialRangeUpTo<Int>) -> String {
        let end = this.index(this.startIndex, offsetBy: min(r.upperBound, this.count))
        return String(this[this.startIndex..<end])
    }

    /// a[index...]
    func subString(_ index: Int) -> String {
        guard index < this.count else {
            return ""
        }
        let start = this.index(this.endIndex, offsetBy: index - this.count)
        return String(this[start..<this.endIndex])
    }

    /// a[start...start+count]
    /// 不具有通用性
    fileprivate func querySubstring(start: Int, _ count: Int) -> String {
        guard start < this.count - 1 else {
            return ""
        }
        guard count > 0 else {
            return ""
        }
        if start == 0 && count == this.count {
            return ""//not return this
        }
        let begin = this.index(this.startIndex, offsetBy: max(0, start))
        let end = this.index(this.startIndex, offsetBy: min(this.count - 1, start + count))
        return String(this[begin...end])
    }

    func substringInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > this.count {
             return nil
         }
         let startIndex = this.index(this.startIndex, offsetBy: r.lowerBound)
         let endIndex   = this.index(this.startIndex, offsetBy: r.upperBound)
         return String(this[startIndex..<endIndex])
     }

}

// MARK: Hash

public extension MBFoundationWrapper where T == String {

    func md2String() -> String? {
        this.digestString(using: .md2)
    }

    func md4String() -> String? {
        this.digestString(using: .md4)
    }

    func md5String() -> String? {
        this.digestString(using: .md5)
    }

    func sha1String() -> String? {
        this.digestString(using: .sha1)
    }

    func sha224String() -> String? {
        this.digestString(using: .sha224)
    }

    func sha256String() -> String? {
        this.digestString(using: .sha256)
    }

    func sha384String() -> String? {
        this.digestString(using: .sha384)
    }

    func sha512String() -> String? {
        this.digestString(using: .sha512)
    }

    func hmacMD5String(withKey: String) -> String? {
        ""
    }

    func hmacSHA1String(withKey: String) -> String? {
        ""
    }

    func hmacSHA224String(withKey: String) -> String? {
        ""
    }

    func hmacSHA256String(withKey: String) -> String? {
        ""
    }

    func hmacSHA384String(withKey: String) -> String? {
        ""
    }

    func hmacSHA512String(withKey: String) -> String? {
        ""
    }

    func crc32String() -> NSString? {
        ""
    }

}

private let encodeURIAllowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789;,/?:@&=+$-_.!~*'()#")
private let encodeURIComponentAllowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.!~*'()")

// MARK: Encode & Decode

public extension MBFoundationWrapper where T == String {

    func utf8EncodeData() -> Data {
        Data(this.utf8)
    }

    func base64EncodedString() -> String? {
        this.data(using: .utf8)?.base64EncodedString()
    }

    func base64DecodedString() -> String? {
        guard let data = Data(base64Encoded: this) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// 参考资料：
    /// [RFC3986](https://www.ietf.org/rfc/rfc3986.txt)
    /// [迷雾重重的 URL encode](https://tech.amh-group.com/#/posts/detail?id=1519&anchor=)
    /// [encodeURI](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/encodeURI)
    /// [encodeURIComponent()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent)
    ///
    /// RFC3986标准：
    /// 定义保留字符18个 👉 !*'();:@&=+$,/?#[] 👈
    ///
    /// AFN补充说明：
    /// NSString * AFPercentEscapedStringFromString(NSString *string) 仅仅是针对URL Query部分 field和value进行百分比编码
    /// 并且由于 RFC 3986 - Section 3.4，AFN这里移除了两个保留字符 👉 /？👈 仅剩16个保留字符
    ///
    /// Apple提供URL组成成分无需百分比编码的字符集合说明：
    /// CharacterSet.urlHostAllowed     👉 "#%/<>?@\^`{|}  👈
    /// CharacterSet.urlPathAllowed     👉 "#%;<>?[\]^`{|} 👈
    /// CharacterSet.urlUserAllowed     👉 "#%/:<>?@[\]^`  👈
    /// CharacterSet.urlQueryAllowed    👉 "#%<>[\]^`{|}  👈
    /// CharacterSet.urlPasswordAllowed 👉 "#%/:<>?@[\]^`{|}  👈
    /// CharacterSet.urlFragmentAllowed 👉 "#%<>[\]^`{|}  👈
    ///
    /// "encodeURI" 与 "encodeURIComponent" 区别测试代码：
    ///
    /// var set1 = ";,/?:@&=+$";  // 保留字符
    /// var set2 = "-_.!~*'()";   // 不转义字符
    /// var set3 = "#";           // 数字标志
    /// var set4 = "ABC abc 123"; // 字母数字字符和空格
    ///
    /// console.log(encodeURI(set1)); // ;,/?:@&=+$
    /// console.log(encodeURI(set2)); // -_.!~*'()
    /// console.log(encodeURI(set3)); // #
    /// console.log(encodeURI(set4)); // ABC%20abc%20123 (the space gets encoded as %20)
    ///
    /// console.log(encodeURIComponent(set1)); // %3B%2C%2F%3F%3A%40%26%3D%2B%24
    /// console.log(encodeURIComponent(set2)); // -_.!~*'()
    /// console.log(encodeURIComponent(set3)); // %23
    /// console.log(encodeURIComponent(set4)); // ABC%20abc%20123 (the space gets encoded as %20)
    ///
    /// 旧API实现说明：
    ///
    /// 方法一：
    /// 源自：MBToolKit NSString+MBExtends.h
    /// 实现：
    /// - (NSString *)URLEncodingString {
    ///    CFStringRef ref = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`", kCFStringEncodingUTF8 );
    ///    CFAutorelease(ref);
    ///    return (__bridge NSString *)ref;
    /// }
    ///
    /// 方法二：
    /// 源自：
    /// 实现：MBToolKit NSString+MBExtends.h
    /// static NSString * const kTRCharactersToBeEscapedInQueryString = @":/?#[]@!$&’()*+,;=.";
    /// - (NSString *)encodeString {
    ///     NSString *encodedStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
    ///                                                                                                (CFStringRef)self,
    ///                                                                                                NULL,
    ///                                                                                                (__bridge CFStringRef)kTRCharactersToBeEscapedInQueryString,
    ///                                                                                                kCFStringEncodingUTF8)
    ///                                                        );
    ///    return encodedStr;
    /// }
    ///
    ///

    func encodeString() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: ":/?#[]@!$&’()*+,;=.").inverted
        return this.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    func decodeString() -> String? {
        this.removingPercentEncoding
    }
    
    func encodeURI() -> String? {
        this.addingPercentEncoding(withAllowedCharacters: encodeURIAllowedCharacters)
    }

    func decodeURI() -> String? {
        this.removingPercentEncoding
    }

    func encodeURIComponent() -> String? {
        this.addingPercentEncoding(withAllowedCharacters: encodeURIComponentAllowedCharacters)
    }

    func decodeURIComponent() -> String? {
        this.removingPercentEncoding
    }
    
    func URLEncodingString() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`").inverted
        return this.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    func hmacURLEncodingString() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: ":/?#[]@!$ &'()+,;=\"<>%{}|\\^~`").inverted
        return this.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }

    func urlQueryString() -> String? {
        var queryRange = NSRange(location: 0, length: this.count)

        let anchorPointRange = this.range(of: "#")

        if let anchorPointNSRange = self.nsRange(from: anchorPointRange) {
            if anchorPointNSRange.location != NSNotFound {
                queryRange.length -= (queryRange.length - anchorPointNSRange.location)
            }
        }

        let questionMarkRange = this.range(of: "?")
        if let questionMarkNSRange = self.nsRange(from: questionMarkRange) {
            if questionMarkNSRange.location != NSNotFound {
                queryRange.location = questionMarkNSRange.location
                queryRange.length -= (queryRange.location + 1)
            }
        }

        let equalMarkRange = self.querySubstring(start: queryRange.location, queryRange.length).range(of: "=")

        if let questionMarkNSRange = self.nsRange(from: questionMarkRange), questionMarkNSRange.location == NSNotFound {
            if let equalMarkNSRange = self.nsRange(from: equalMarkRange), equalMarkNSRange.location == NSNotFound {
                queryRange = NSRange(location: NSNotFound, length: 0)
            }
        }

        if queryRange.location == NSNotFound {
            return nil
        }

        let queryString = self.querySubstring(start: queryRange.location, queryRange.length)

        let resultString = queryString.hasPrefix("?") ? queryString.mb[1...] : queryString
        return resultString
    }

    func urlQueryParams() -> [String: String]? {
        guard let queryString = self.urlQueryString() else { return nil }
        var queryParams = [String: String]()
        for param in queryString.components(separatedBy: "&") {
            let paramString = param as NSString
            let equalRange = paramString.range(of: "=")
            if equalRange.location == NSNotFound {
                continue
            }
            let key = paramString.substring(to: equalRange.location)
            let value = paramString.length > (equalRange.location + equalRange.length) ? paramString.substring(from: equalRange.location + equalRange.length) : ""
            if !key.isEmpty && !value.isEmpty {
                queryParams.updateValue(value, forKey: key)
            }
        }
        return queryParams
    }

}

// MARK: Regular Expression

public extension MBFoundationWrapper where T == String {

    func matchesRegx(pattern: String, options: NSRegularExpression.Options) -> Bool {
        var isMatch = false
        do {
            let regular = try NSRegularExpression(pattern: pattern, options: options)
            let range = NSRange(location: 0, length: this.count)
            if regular.numberOfMatches(in: this, options: .reportProgress, range: range) > 0 {
                isMatch = true
            }
        } catch {
            print(error)
        }
        return isMatch
    }

    func enumerateRegexMatches(_: String, options: NSRegularExpression.Options, using block: (NSString, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {

    }

    func stringByReplacingRegex(_ regex: String, options: NSRegularExpression.Options, withString replacement: NSString) -> NSString {
        guard let pattern = try? NSRegularExpression.init(pattern: regex, options: options) else { return this as NSString }
        return pattern.stringByReplacingMatches(in: this, options:.reportProgress, range: NSMakeRange(0, this.count), withTemplate: replacement as String) as NSString
    }

    func evaluateWith(regx: String) -> Bool {
        NSPredicate(format: "SELF MATCHES %@", regx).evaluate(with: this)
    }

    func isNumbers() -> Bool {
        evaluateWith(regx: "^\\d+$")
    }

    func isCharacters() -> Bool {
        evaluateWith(regx: "^\\w+$")
    }

    func isChinese() -> Bool {
        evaluateWith(regx: "^[\\u4e00-\\u9fa5]+$")
    }

    func isEmail() -> Bool {
        evaluateWith(regx: "^\\b[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\\.)+[A-Za-z]{2,6}\\b$")
    }

    func isIP() -> Bool {
        evaluateWith(regx: "^((25[0-5]|2[0-4]\\d|1?\\d{1,2})\\.){3}(25[0-5]|2[0-4]\\d|1?\\d{1,2})$")
    }

    func isIdentify() -> Bool {
        evaluateWith(regx: "^(\\d{14}|\\d{17})(\\d|[xX])$")
    }

    func isMobile() -> Bool {
        evaluateWith(regx: "^1\\d{10}$")
    }

    func isTelephone() -> Bool {
        evaluateWith(regx: "^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$")
    }

    func isAmount() -> Bool {
        evaluateWith(regx: "^(0(\\.\\d{0,2})?)|([1-9]\\d*(.\\d{0,2})?)$")
    }

    func isBankCard() -> Bool {
        this.count >= 11 && this.count <= 23
    }

    func isCaptcha() -> Bool {
        evaluateWith(regx: "\\d{4}")
    }

    func isPureInt() -> Bool {
        let scanner = Scanner(string: this)
        var val = 0
        return (scanner.scanInt(&val) && scanner.isAtEnd)
    }
}

// MARK: Money

public extension MBFoundationWrapper where T == String {

    private func decimalNumberCompare(string: String) -> ComparisonResult {
        let decimalNumber1 = NSDecimalNumber.init(string: this as String) ?? 0
        let decimalNumber2 = NSDecimalNumber.init(string: string) ?? 0
        return decimalNumber1.compare(decimalNumber2)
    }

    func compareWith(string: String = "0", operation: MoneyCompare) -> Bool {
        switch operation {
            case .greater: return decimalNumberCompare(string: string) == .orderedDescending
            case .greaterAndEqual: return decimalNumberCompare(string: string) != .orderedAscending
            case .less: return decimalNumberCompare(string: string) == .orderedAscending
            case .lessAndEqual: return decimalNumberCompare(string: string) != .orderedDescending
            case .equal: return decimalNumberCompare(string: string) == .orderedSame
            case .notEqual: return decimalNumberCompare(string: string) != .orderedSame
        }
    }

    func calculateWith(string: String = "0", operation: MoneyCalculation) -> String? {
        let decimalNumber1 = NSDecimalNumber.init(string: this as String) ?? 0
        let decimalNumber2 = NSDecimalNumber.init(string: string) ?? 0
        var decimalResult: NSDecimalNumber
        switch operation {
            case .add: decimalResult = decimalNumber1.adding(decimalNumber2)
            case .subtract: decimalResult = decimalNumber1.subtracting(decimalNumber2)
            case .multiply: decimalResult = decimalNumber1.multiplying(by: decimalNumber2)
            case .divide: decimalResult = decimalNumber1.dividing(by: decimalNumber2)
        }
        let handler: NSDecimalNumberHandler = NSDecimalNumberHandler.init(roundingMode: .bankers, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)

        if decimalResult.isEqual(to: NSDecimalNumber.notANumber) {
            return nil
        }

        decimalResult = decimalResult.rounding(accordingToBehavior: handler)
        return decimalResult.stringValue
    }

}

// MARK: Desensitization

public extension MBFoundationWrapper where T == String {

    fileprivate func makeStarsIn(range: NSRange) -> String {
        guard !this.isEmpty else {
            return this
        }
        let maxRange = NSRange(location: 0, length: this.count)
        if !NSEqualRanges(NSIntersectionRange(maxRange, range), range) {
            return this
        }
        var starsString = ""
        for _ in 0..<range.length {
            starsString.append("*")
        }
        return (this as NSString).replacingCharacters(in: range, with: starsString)
    }

    func desensitizedName() -> String {
        makeStarsIn(range: NSRange(location: 1, length: this.count-1))
    }

    func desensitizedSocialName() -> String {
        String(this.prefix(1)) + "师傅"
    }

    func desensitizedTelNumber() -> String {
        makeStarsIn(range: NSRange(location: 4, length: this.count-4-1))
    }

    func desensitizedMobileNumber() -> String {
        makeStarsIn(range: NSRange(location: 3, length: this.count-7))
    }

    func desensitizedIP() -> String {
        let first = this.components(separatedBy: ".")
        return first.count == 1 ? this : "\(this.components(separatedBy: ".").first ?? "").*.*.*"
    }

    func desensitizedEmail() -> String {
        let array = this.components(separatedBy: "@")
        guard array.count == 2 else {
            return this
        }
        var prefix = array.first!
        let suffix = array.last!
        if prefix.count > 3 {
            prefix = prefix.mb.makeStarsIn(range: NSRange(location: 3, length: prefix.count-3))
        } else {
            prefix = prefix.mb.makeStarsIn(range: NSRange(location: 1, length: prefix.count-1))
        }
        return "\(prefix)@\(suffix)"
    }

    func desensitizedBankCard() -> String {
        makeStarsIn(range: NSRange(location: 0, length: this.count-4))
    }

    func desensitizedPassword() -> String {
        makeStarsIn(range: NSRange(location: 0, length: this.count))
    }

    func desensitizedAccount() -> String {
        makeStarsIn(range: NSRange(location: 3, length: this.count-3))
    }

    func desensitizedDrivingLicenseNumber() -> String {
        makeStarsIn(range: NSRange(location: 4, length: this.count-8))
    }

    func desensitizedDrivingLicensedocumentationNumber() -> String {
        makeStarsIn(range: NSRange(location: 3, length: this.count-6))
    }

    func desensitizedIDCardNumber() -> String {
        makeStarsIn(range: NSRange(location: 3, length: this.count-6))
    }

    func desensitizedETCCardNumber() -> String {
        makeStarsIn(range: NSRange(location: 4, length: this.count-8))
    }

    func desensitizedETCCardNumberTypedLong() -> String {
        guard this.count >= 20 else {
            return this
        }
        let head = (this as NSString).substring(to: 4)
        let end = (this as NSString).substring(from: this.count-4)
        return "\(head) **** **** **** \(end)"
    }

    func desensitizedPlateNumber() -> String {
        makeStarsIn(range: NSRange(location: 2, length: this.count-3))
    }

    func desensitizedVIN() -> String {
        makeStarsIn(range: NSRange(location: 3, length: this.count-5))
    }

    func desensitizedEngineID() -> String {
        makeStarsIn(range: NSRange(location: 2, length: this.count-3))
    }

}

// MARK: Emoji

public extension MBFoundationWrapper where T == String {

    /// 是否为单个emoji表情
    var isSingleEmoji: Bool {
        this.count==1 && containsEmoji
    }

    /// 包含emoji表情
    var containsEmoji: Bool {
        this.contains { $0.mb.isEmoji}
    }

    /// 只包含emoji表情
    var containsOnlyEmoji: Bool {
        !this.isEmpty && !this.contains {!$0.mb.isEmoji}
    }

    /// 提取emoji表情字符串
    var emojiString: String {
        emojis.map {String($0) }.reduce("", +)
    }

    /// 提取emoji表情数组
    var emojis: [Character] {
        this.filter { $0.mb.isEmoji}
    }

    /// 提取单元编码标量
    var emojiScalars: [UnicodeScalar] {
        this.filter { $0.mb.isEmoji}.flatMap { $0.unicodeScalars}
    }
}

// MARK: Utilities

public extension MBFoundationWrapper where T == String {

    static func stringWithUUID() -> String {
        UUID().uuidString
    }
    
    static func randomString(len: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<len).map{ _ in letters.randomElement()! })
      }

    func stringByTrim() -> String {
        this.trimmingCharacters(in: .whitespaces)
    }

    func contains(string: String, caseInSensitive: Bool) -> Bool {
        if caseInSensitive {
            return this.range(of: string, options: .caseInsensitive) != nil
        } else {
            return this.range(of: string) != nil
        }
    }

    func dataValue() -> Data {
        Data(this.utf8)
    }

    func jsonValueDecoded() -> Any? {
        dataValue().mb.jsonValueDecoded()
    }

    var uppercase: String {
        this.uppercased()
    }

    var lowercase: String {
        this.lowercased()
    }

    func OSSUrlStringWithImageSize(_ size: CGSize) -> String {
        let ossKey = "x-oss-process"
        let contentType = "image/resize"
        let fillType = "m_fill"
        let widthPx = Int(size.width*2)
        let heightPx = Int(size.height*2)
        let widthPxString = String(format: "w_%ld", widthPx)
        let heightPxString = String(format: "h_%ld", heightPx)
        let ossValue = String(format: "%@,%@,%@,%@", contentType, fillType, widthPxString, heightPxString)

        if this.contains("?") {
            let array = this.components(separatedBy: "?")
            let path = (array.first ?? "")
            let param = (array.last ?? "")
            return String(format: "%@?%@=%@&%@", path, ossKey, ossValue, param)
        } else {
            return String(format: "%@?%@=%@", this, ossKey, ossValue)
        }
    }

    func filterEmoji() -> String? {
        do {
            let regx = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
            return regx.stringByReplacingMatches(in: this, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: this.count), withTemplate: "")
        } catch {
            return nil
        }
    }

    func appendURLQueryParameters(_ params: [String: String]) -> String? {
        guard !params.isEmpty else {
            return this
        }
        guard var components = URLComponents(string: this) else {
            return appendURLQueryParametersUsingStringMatching(params)
        }

        var querys: [URLQueryItem?] = []
        if let queryItems = components.queryItems {
            querys.append(contentsOf: queryItems)
        }

        for (key, value) in params {
            var targetIndex = NSNotFound
            for item in querys {
                if item?.name == key {
                    targetIndex = querys.firstIndex(of: item) ?? NSNotFound
                    break
                }
            }
            if targetIndex != NSNotFound {
                querys.remove(at: targetIndex)
            }
            querys.append(URLQueryItem(name: key, value: value))
        }

        if let querys = querys as? [URLQueryItem] {
            components.queryItems = querys
            return components.url?.absoluteString
        }

        return nil
    }
    
    func appendingQueryValue(_ value: String, forKey key: String) -> String {
        return appendURLQueryParametersUsingStringMatching([key: value])
    }
    
    // 忽略url，使用纯字符串替换的方式处理URL参数，存在#多次替换的历史问题
    func appendURLQueryParametersUsingStringMatching(_ params: [String: String]) -> String {
        guard !params.isEmpty else {
            return this
        }
        let queryParis = params.map { (key, value) -> String in
            return String(format: "%@=%@", key, value)
        }
        let queryString = (queryParis as NSArray).componentsJoined(by: "&")
        var range = (this as NSString).range(of: "?")
        if range.location == NSNotFound {
            range = (this as NSString).range(of: "#")
            return range.location == NSNotFound ? this.appendingFormat("?%@", queryString) : this.replacingOccurrences(of: "#", with: String(format: "?%@#", queryString), options: .literal)
        } else {
            return this.replacingOccurrences(of: "?", with: String(format: "?%@&", queryString), options: .literal)
        }
    }
}

// MARK: Encrypt & Decrypt

internal extension MBFoundationWrapper where T == String {

    func aes128Encrypt(key: String, iv: String? = nil) -> String? {
        guard let data = this.data(using: .utf8) else { return nil }
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        if let encryptData = Cryptor.symmetricEncrypt(algorithm: .aes_128, data: data, key: keyData, iv: ivData) {
            return encryptData.base64EncodedString(options: .lineLength64Characters)
        }
        return nil
    }

    func aes128Decrypt(key: String, iv: String? = nil) -> String? {
        guard let data = Data(base64Encoded: this, options: .ignoreUnknownCharacters) else { return nil }
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        if let decryptData = Cryptor.symmetricDecrypt(algorithm: .aes_128, data: data, key: keyData, iv: ivData) {
            return decryptData.mb.utf8String()
        }
        return nil
    }

    func desEncrypt(key: String, iv: String? = nil) -> String? {
        guard let data = this.data(using: .utf8) else { return nil }
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        if let encryptData = Cryptor.symmetricEncrypt(algorithm: .des, data: data, key: keyData, iv: ivData) {
            return encryptData.mb.utf8String()
        }
        return nil
    }

    func desDecrypt(key: String, iv: String? = nil) -> String? {
        guard let data = this.data(using: .utf8) else { return nil }
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        if let decryptData = Cryptor.symmetricDecrypt(algorithm: .des, data: data, key: keyData, iv: ivData) {
            return decryptData.mb.utf8String()
        }
        return nil
    }

    func threeDesEncrypt(key: String, iv: String? = nil) -> String? {
        guard let data = this.data(using: .utf8) else { return nil }
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        if let encryptData = Cryptor.symmetricEncrypt(algorithm: .tripleDES, data: data, key: keyData, iv: ivData) {
            return encryptData.mb.utf8String()
        }
        return nil
    }

    func threeDesDecrypt(key: String, iv: String? = nil) -> String? {
        guard let data = this.data(using: .utf8) else { return nil }
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        if let decryptData = Cryptor.symmetricDecrypt(algorithm: .tripleDES, data: data, key: keyData, iv: ivData) {
            return decryptData.mb.utf8String()
        }
        return nil
    }

    func rsaEncrypt(publicKey: String) -> String? {
        guard let data = this.data(using: .utf8) else { return nil }
        if let encryptData = Cryptor.asymmetricEncrypt(data: data, publicKey: publicKey) {
            return encryptData.mb.utf8String()
        }
        return nil
    }

    func rsaDecrypt(privateKey: String) -> String? {
        guard let data = this.data(using: .utf8) else { return nil }
        if let decryptData = Cryptor.asymmetricDecrypt(data: data, privateKey: privateKey) {
            return decryptData.mb.utf8String()
        }
        return nil
    }

}

internal extension MBFoundationWrapper where T == String {

    subscript (i: Int) -> Character {
        return this[this.index(this.startIndex, offsetBy: i)]
    }

    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = this.index(this.startIndex, offsetBy: bounds.lowerBound)
        let end = this.index(this.startIndex, offsetBy: bounds.upperBound)
        return this[start ..< end]
    }

    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = this.index(this.startIndex, offsetBy: bounds.lowerBound)
        let end = this.index(this.startIndex, offsetBy: bounds.upperBound)
        return this[start ... end]
    }

    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = this.index(this.startIndex, offsetBy: bounds.lowerBound)
        let end = this.index(this.endIndex, offsetBy: -1)
        return this[start ... end]
    }

    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = this.index(this.startIndex, offsetBy: bounds.upperBound)
        return this[this.startIndex ... end]
    }

    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = this.index(this.startIndex, offsetBy: bounds.upperBound)
        return this[this.startIndex ..< end]
    }

}

internal extension MBFoundationWrapper where T == Substring {

    subscript (i: Int) -> Character {
        return this[this.index(this.startIndex, offsetBy: i)]
    }

    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = this.index(this.startIndex, offsetBy: bounds.lowerBound)
        let end = this.index(this.startIndex, offsetBy: bounds.upperBound)
        return this[start ..< end]
    }

    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = this.index(this.startIndex, offsetBy: bounds.lowerBound)
        let end = this.index(this.startIndex, offsetBy: bounds.upperBound)
        return this[start ... end]
    }

    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = this.index(this.startIndex, offsetBy: bounds.lowerBound)
        let end = this.index(this.endIndex, offsetBy: -1)
        return this[start ... end]
    }

    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = this.index(this.startIndex, offsetBy: bounds.upperBound)
        return this[this.startIndex ... end]
    }

    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = this.index(this.startIndex, offsetBy: bounds.upperBound)
        return this[this.startIndex ..< end]
    }

}

@objc
public enum MoneyCompare: Int {
    case greater
    case greaterAndEqual
    case less
    case lessAndEqual
    case equal
    case notEqual
}

@objc
public enum MoneyCalculation: Int {
    case add
    case subtract
    case multiply
    case divide
}

// MARK: NSString
@objc
public extension NSString {

    // MARK: Hash

    func mb_md2String() -> NSString? {
        (self as String).mb.md2String() as NSString?
    }

    func mb_md4String() -> NSString? {
        (self as String).mb.md4String() as NSString?
    }

    func mb_md5String() -> NSString? {
        return (self as String).mb.md5String() as NSString?
    }
    
    func mb_md5For16BateString() -> NSString? {
        let md5Str = (self as String).mb.md5String() as NSString?
    
        var string: NSString?
        for _ in 0..<24 {
            string = md5Str?.substring(with: NSMakeRange(8, 16)) as NSString?
        }
        return string
    }

    func mb_sha1String() -> NSString? {
        return (self as String).mb.sha1String() as NSString?
    }

    func mb_sha224String() -> NSString? {
        (self as String).mb.sha224String() as NSString?
    }

    func mb_sha256String() -> NSString? {
        return (self as String).mb.sha256String() as NSString?
    }

    func mb_sha384String() -> NSString? {
        (self as String).mb.sha384String() as NSString?
    }

    func mb_sha512String() -> NSString? {
        (self as String).mb.sha512String() as NSString?
    }

    func mb_hmacMD5String(withKey: NSString) -> NSString? {
        (self as String).mb.hmacMD5String(withKey: withKey as String) as NSString?
    }

    func mb_hmacSHA1String(withKey: NSString) -> NSString? {
        (self as String).mb.hmacSHA1String(withKey: withKey as String) as NSString?
    }

    func mb_hmacSHA224String(withKey: NSString) -> NSString? {
        (self as String).mb.hmacSHA224String(withKey: withKey as String) as NSString?
    }

    func mb_hmacSHA256String(withKey: NSString) -> NSString? {
        (self as String).mb.hmacSHA256String(withKey: withKey as String) as NSString?
    }

    func mb_hmacSHA384String(withKey: NSString) -> NSString? {
        (self as String).mb.hmacSHA384String(withKey: withKey as String) as NSString?
    }

    func mb_hmacSHA512String(withKey: NSString) -> NSString? {
        (self as String).mb.hmacSHA512String(withKey: withKey as String) as NSString?
    }

    func mb_crc32String() -> NSString? {
        (self as String).mb.crc32String() as NSString?
    }

    // MARK: Encode & Decode

    func mb_utf8EncodeData() -> NSData {
        return (self as String).mb.utf8EncodeData() as NSData
    }

    func mb_base64EncodedString() -> NSString? {
        return (self as String).mb.base64EncodedString() as NSString?
    }

    func mb_base64DecodedString() -> NSString? {
        return (self as String).mb.base64DecodedString() as NSString?
    }

    func mb_encodeString() -> NSString? {
        return (self as String).mb.encodeString() as NSString?
    }
    
    func mb_decodeString() -> NSString? {
        (self as String).mb.decodeString() as NSString?
    }
    
    func mb_URLEncodingString() -> NSString? {
        (self as String).mb.URLEncodingString() as NSString?
    }
    
    func mb_hmacURLEncodingString() -> NSString? {
        (self as String).mb.hmacURLEncodingString() as NSString?
    }
    
    func mb_encodeURI() -> NSString? {
        (self as String).mb.encodeURI() as NSString?
    }

    func mb_decodeURI() -> NSString? {
        (self as String).mb.decodeURI() as NSString?
    }

    func mb_encodeURIComponent() -> NSString? {
        (self as String).mb.encodeURIComponent() as NSString?
    }

    func mb_decodeURIComponent() -> NSString? {
        (self as String).mb.decodeURIComponent() as NSString?
    }

    func mb_urlQueryString() -> NSString? {
        (self as String).mb.urlQueryString() as NSString?
    }

    func mb_urlQueryParams() -> [String: String]? {
        (self as String).mb.urlQueryParams()
    }

    // MARK: Regular Expression

    func mb_matchesRegx(pattern: NSString, options: NSRegularExpression.Options) -> Bool {
        (self as String).mb.matchesRegx(pattern: pattern as String, options: options)
    }

    func mb_enumerateRegexMatches(_ string: NSString, options: NSRegularExpression.Options, using block: (NSString, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
        (self as String).mb.enumerateRegexMatches(string as String, options: options, using: block)
    }

    func mb_stringByReplacingRegex(_ string: NSString, options: NSRegularExpression.Options, withString replacement: NSString) -> NSString {
        (self as String).mb.stringByReplacingRegex(string as String, options: options, withString: replacement)
    }

    func mb_evaluateWith(regx: NSString) -> Bool {
        (self as String).mb.evaluateWith(regx: regx as String)
    }
    
    func mb_isValidNumber() -> Bool {
        (self as String).mb.evaluateWith(regx: "[0-9]*")
    }

    func mb_isValidMobileNumber() -> Bool {
        (self as String).mb.evaluateWith(regx: "^(1)\\d{10}$")
    }
    
    func mb_isValidLandlineNumber() -> Bool {
        (self as String).mb.evaluateWith(regx: "0\\d{10,11}")
    }
    
    func mb_isValidTelephone() -> Bool {
        mb_isValidMobileNumber() || mb_isValidLandlineNumber()
    }
    
    func mb_isValidPassword() -> Bool {
        (self as String).mb.evaluateWith(regx: "\\w{6,16}")
    }
    
    func mb_isValidCaptcha() -> Bool {
        (self as String).mb.evaluateWith(regx: "\\d{4}")
    }
    
    func mb_isValidTruckNumber() -> Bool {
        (self as String).mb.evaluateWith(regx: "^[\u{4e00}-\u{9fa5}]{1}[A-Z]{1}[A-Z0-9]{5,6}$")
    }
    
    func mb_isValidUserName() -> Bool {
        (self as String).mb.evaluateWith(regx: "^[\u{4E00}-\u{9FA5}]*$")
    }
    
    func mb_isValidIDNumber() -> Bool {
        (self as String).mb.evaluateWith(regx: "^(\\d{6})(18|19|20)?(\\d{2})([01]\\d)([0123]\\d)(\\d{3})(\\d|X|x)?$")
    }
    
    func mb_isValidUserNameForAuth() -> Bool {
        (self as String).mb.evaluateWith(regx: "(^[\u{4E00}-\u{9FA5}]+((·)?[\u{4E00}-\u{9FA5}])+$)|(^[A-Za-z]+((·)?[A-Za-z])+$)")
    }
    
    func mb_isChinaMobileNumber() -> Bool {
        if mb_isValidMobileNumber() {
            let sub = self.substring(with:NSMakeRange(1, 2)) as NSString
            let subArray = [34, 35, 36, 37, 38, 39, 47, 50, 51, 52, 58, 59, 82, 83, 84, 87, 88]
            if subArray.contains(sub.integerValue) {
                return true
            }
            return false
        }
        return false
    }
    
    func mb_isTwoDecimalFloat() -> Bool {
        (self as String).mb.evaluateWith(regx: "^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$")
    }
    
    func mb_isOneDecimalFloat() -> Bool {
        (self as String).mb.evaluateWith(regx: "^\\-?([1-9]\\d*|0)(\\.\\d{0,1})?$")
    }
    
    func mb_isValidAddress() -> Bool {
        (self as String).mb.evaluateWith(regx: "^[a-zA-Z0-9_\\——\\－\\-\u{4e00}-\u{9fa5}]+$")
    }
    
    func mb_isNumbers() -> Bool {
        (self as String).mb.isNumbers()
    }

    func mb_isCharacters() -> Bool {
        (self as String).mb.isCharacters()
    }

    func mb_isChinese() -> Bool {
        (self as String).mb.isChinese()
    }

    func mb_isEmail() -> Bool {
        (self as String).mb.isEmail()
    }

    func mb_isIP() -> Bool {
        (self as String).mb.isIP()
    }

    func mb_isIdentify() -> Bool {
        (self as String).mb.isIdentify()
    }

    func mb_isMobile() -> Bool {
        (self as String).mb.isMobile()
    }

    func mb_isTelephone() -> Bool {
        (self as String).mb.isTelephone()
    }

    func mb_isAmount() -> Bool {
        (self as String).mb.isAmount()
    }

    func mb_isBankCard() -> Bool {
        (self as String).mb.isBankCard()
    }

    func mb_isPureInt() -> Bool {
        (self as String).mb.isPureInt()
    }

    func mb_isCaptcha() -> Bool {
        (self as String).mb.isCaptcha()
    }

    // MARK: Money

    func mb_compareWith(string: NSString = "0", operation: MoneyCompare) -> Bool {
        (self as String).mb.compareWith(string: string as String, operation: operation)
    }

    func mb_calculateWith(string: NSString = "0", operation: MoneyCalculation) -> String? {
        (self as String).mb.calculateWith(string: string as String, operation: operation)
    }

    // MARK: Desensitization

    func mb_desensitizedName() -> NSString {
        (self as String).mb.desensitizedName() as NSString
    }

    func mb_desensitizedSocialName() -> NSString {
        (self as String).mb.desensitizedSocialName() as NSString
    }

    func mb_desensitizedTelNumber() -> NSString {
        (self as String).mb.desensitizedTelNumber() as NSString
    }

    func mb_desensitizedMobileNumber() -> NSString {
        (self as String).mb.desensitizedMobileNumber() as NSString
    }

    func mb_desensitizedIP() -> NSString {
        (self as String).mb.desensitizedIP() as NSString
    }

    func mb_desensitizedEmail() -> NSString {
        (self as String).mb.desensitizedEmail() as NSString
    }

    func mb_desensitizedBankCard() -> NSString {
        (self as String).mb.desensitizedBankCard() as NSString
    }

    func mb_desensitizedPassword() -> NSString {
        (self as String).mb.desensitizedPassword() as NSString
    }

    func mb_desensitizedAccount() -> NSString {
        (self as String).mb.desensitizedAccount() as NSString
    }

    func mb_desensitizedDrivingLicenseNumber() -> NSString {
        (self as String).mb.desensitizedDrivingLicenseNumber() as NSString
    }

    func mb_desensitizedDrivingLicensedocumentationNumber() -> NSString {
        (self as String).mb.desensitizedDrivingLicensedocumentationNumber() as NSString
    }

    func mb_desensitizedIDCardNumber() -> NSString {
        (self as String).mb.desensitizedIDCardNumber() as NSString
    }

    func mb_desensitizedETCCardNumber() -> NSString {
        (self as String).mb.desensitizedETCCardNumber() as NSString
    }

    func mb_desensitizedETCCardNumberTypedLong() -> NSString {
        (self as String).mb.desensitizedETCCardNumberTypedLong() as NSString
    }

    func mb_desensitizedPlateNumber() -> NSString {
        (self as String).mb.desensitizedPlateNumber() as NSString
    }

    func mb_desensitizedVIN() -> NSString {
        (self as String).mb.desensitizedVIN() as NSString
    }

    func mb_desensitizedEngineID() -> NSString {
        (self as String).mb.desensitizedEngineID() as NSString
    }

    // MARK: Emoji

    func mb_isSingleEmoji() -> Bool {
        (self as String).mb.isSingleEmoji
    }

    func mb_containsEmoji() -> Bool {
        (self as String).mb.containsEmoji
    }

    func mb_containsOnlyEmoji() -> Bool {
        (self as String).mb.containsOnlyEmoji
    }

    func mb_emojiString() -> NSString {
        (self as String).mb.emojiString as NSString
    }

    // MARK: Utilities

    class func mb_stringWithUUID() -> NSString {
        String.mb.stringWithUUID() as NSString
    }

    class func mb_randomString(len: Int) -> NSString {
        return String.mb.randomString(len: len) as NSString
    }

    func mb_stringByTrim() -> NSString {
        (self as String).mb.stringByTrim() as NSString
    }

    func mb_contains(string: NSString, caseInSensitive: Bool) -> Bool {
        (self as String).mb.contains(string: string as String, caseInSensitive: caseInSensitive)
    }

    func mb_dataValue() -> NSData {
        (self as String).mb.dataValue() as NSData
    }

    func mb_jsonValueDecoded() -> Any? {
        (self as String).mb.jsonValueDecoded()
    }

    func mb_uppercase() -> NSString {
        (self as String).mb.uppercase as NSString
    }

    func mb_lowercase() -> NSString {
        (self as String).mb.lowercase as NSString
    }

    func mb_OSSUrlStringWithImageSize(_ size: CGSize) -> NSString {
        return (self as String).mb.OSSUrlStringWithImageSize(size) as NSString
    }

    func mb_filterEmoji() -> NSString? {
        return (self as String).mb.filterEmoji() as NSString?
    }

    func mb_appendURLQueryParameters(_ params: [String: String]) -> NSString? {
        (self as String).mb.appendURLQueryParameters(params) as NSString?
    }
    
    // 忽略url，使用纯字符串替换的方式处理URL参数，存在#多次替换的历史问题
    func mb_appendURLQueryParametersUsingStringMatching(_ params: [String: String]) -> NSString {
        (self as String).mb.appendURLQueryParametersUsingStringMatching(params) as NSString
    }
    
    func mb_appendingQueryValue(_ value: String, forKey key: String) -> NSString? {
        (self as String).mb.appendingQueryValue(value, forKey: key) as NSString?
    }

    func mb_isNotBlank() -> Bool {
        let blank = NSMutableCharacterSet.whitespaceAndNewline()
        for i in 0..<self.length {
            let c = self.character(at: i)
            guard blank.characterIsMember(c) else { return true }
            continue
        }
        return false
    }

    static func mb_isNilOrEmpty(_ string: Any?) -> Bool {
        guard let string = string as? NSString else { return true }
        return string.length == 0
    }

    // MARK: Encrypt & Decrypt

    static func mb_aes128Encrypt(string: String, keyAndIv: String) -> NSString? {
        string.mb.aes128Encrypt(key: keyAndIv, iv: keyAndIv) as NSString?
    }
    
    static func mb_aes128Encrypt(string: String, key: String, iv: String) -> NSString? {
        string.mb.aes128Encrypt(key: key, iv: iv) as NSString?
    }
    
    func mb_aes128Encrypt(key: NSString, iv: NSString? = nil) -> NSString? {
        (self as String).mb.aes128Encrypt(key: key as String, iv: iv as String?) as NSString?
    }

    static func mb_aes128Decrypt(string: String, keyAndIv: String) -> NSString? {
        string.mb.aes128Decrypt(key: keyAndIv, iv: keyAndIv) as NSString?
    }
    
    static func mb_aes128Decrypt(string: String, key: String, iv: String) -> NSString? {
        string.mb.aes128Decrypt(key: key, iv: iv) as NSString?
    }
    
    func mb_aes128Decrypt(key: NSString, iv: NSString? = nil) -> NSString? {
        (self as String).mb.aes128Decrypt(key: key as String, iv: iv as String?) as NSString?
    }

    func mb_desEncrypt(key: NSString, iv: NSString? = nil) -> NSString? {
        (self as String).mb.desEncrypt(key: key as String, iv: iv as String?) as NSString?
    }

    func mb_desDecrypt(key: NSString, iv: NSString? = nil) -> NSString? {
        (self as String).mb.desDecrypt(key: key as String, iv: iv as String?) as NSString?
    }

    func mb_3desEncrypt(key: NSString, iv: NSString? = nil) -> NSString? {
        (self as String).mb.threeDesEncrypt(key: key as String, iv: iv as String?) as NSString?
    }

    func mb_3desDecrypt(key: NSString, iv: NSString? = nil) -> NSString? {
        (self as String).mb.threeDesDecrypt(key: key as String, iv: iv as String?) as NSString?
    }

    func mb_rsaEncrypt(publicKey: NSString) -> NSString? {
        (self as String).mb.rsaEncrypt(publicKey: publicKey as String) as NSString?
    }

    func mb_rsaDecrypt(privateKey: NSString) -> NSString? {
        (self as String).mb.rsaDecrypt(privateKey: privateKey as String) as NSString?
    }
    
    // MARK: String Url
    
    static var MBString_MBFileURL = ""
    
    static func mb_setAppFileUrlString(_ fileUrl: String?) {
        if let string = fileUrl {
            NSString.MBString_MBFileURL = string
        }
    }
    
    func mb_absoluteURL() -> NSURL? {
        if let string = self.mb_absoluteURLString() {
            return NSURL.init(string: (string as String))
        }
        return nil
    }
    
    func mb_absoluteURLString() -> NSString? {
        if self.hasPrefix("http") || self.hasPrefix("https") {
            return self
        }
        if self.length > 0 {
            if self.hasPrefix("/logistics/") || self.hasPrefix("/ymmfile/") {
                return NSString.init(format: "%@%@", NSString.MBString_MBFileURL, self)
            } else if self.hasPrefix("ymmfile/") {
                return NSString(format: "%@/%@", NSString.MBString_MBFileURL, self)
            } else if self.hasPrefix("/var/mobile") {//手机路径,不能添加 fileurl
                return self;
            } else if self.hasPrefix("/") {
                return NSString(format: "%@%@", NSString.MBString_MBFileURL, self)
            } else {
                return NSString(format: "%@/%@", NSString.MBString_MBFileURL,self)
            }
        }
        return nil
    }
    
    func mb_imageCacheKeyFilter() -> NSString? {
           guard let url = self.mb_absoluteURL() else {return self}
           guard let host = url.host else {return self}
           
           if !(host.hasSuffix("ymm56.com") || host.hasSuffix("ymmconfidential2.oss-cn-shanghai.aliyuncs.com") || host.hasSuffix("56qq.com")) {
               // 非满帮图片
               return self.mb_absoluteURLString()
           }
        
           // 满帮图片
           let privateBucketImageParams: [String] = ["Expires", "OSSAccessKeyId", "Signature"]
           guard let queryString = url.query else {
               // 满帮共有仓图片
               return self.mb_absoluteURLString()
           }
           for privateBucketImageParam in privateBucketImageParams {
               if(!(queryString as NSString).contains(privateBucketImageParam)){
                   // 满帮共有仓图片
                   return self.mb_absoluteURLString()
               }
           }
           // 满帮私有仓图片
           guard var components = URLComponents(url: url as URL, resolvingAgainstBaseURL: false) else {return self}
           guard let queryItems = components.queryItems else {return self}
           components.queryItems = queryItems.filter({ queryItem in
               !privateBucketImageParams.contains(queryItem.name)
           })
           return components.url?.absoluteString as NSString?           
       }
}

// MARK: - Properties

public extension String {

    /// Check if string is a valid URL.
    ///
    ///        "https://google.com".isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }

    /// Check if string is a valid schemed URL.
    ///
    ///        "https://google.com".isValidSchemedUrl -> true
    ///        "google.com".isValidSchemedUrl -> false
    ///
    var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// Check if string is a valid https URL.
    ///
    ///        "https://google.com".isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }

    /// Check if string is a valid http URL.
    ///
    ///        "http://google.com".isValidHttpUrl -> true
    ///
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }

    /// Check if string is a valid file URL.
    ///
    ///        "file://Documents/file.txt".isValidFileUrl -> true
    ///
    var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }

    /// URL from string (if applicable).
    ///
    ///        "https://google.com".url -> URL(string: "https://google.com")
    ///        "not url".url -> nil
    ///
    var url: URL? {
        return URL(string: self)
    }
    
    ///  Bool value from string (if applicable).
    ///
    ///        "1".bool -> true
    ///        "False".bool -> false
    ///        "Hello".bool = nil
    ///
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    /// Date object from "yyyy-MM-dd" formatted string.
    ///
    ///        "2007-06-29".date -> Optional(Date)
    ///
    var date: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }

    /// Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    ///
    ///        "2007-06-29 14:23:09".dateTime -> Optional(Date)
    ///
    var dateTime: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }

    /// Integer value from string (if applicable).
    ///
    ///        "101".int -> 101
    ///
    var int: Int? {
        return Int(self)
    }

}

// MARK: - Methods

public extension String {

    /// Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }

    /// Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }

    /// CGFloat value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional CGFloat value from given string.
    func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
    
    /// 快速拼接一个缓存目录的路径
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent(self)
     }

     /// 快速拼接一个文档目录的路径
     func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent(self)
     }
     /// 快速拼接一个临时目录的路径
     func tmpDir() -> String {
         let path = NSTemporaryDirectory()
         return (path as NSString).appendingPathComponent(self)
     }

}

// MARK: - subscripts

public extension String {

    /// 字符串截取，可数闭区间
    ///
    ///     "helloworld"[0...4] -> "hello"
    ///
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
     }

    /// 字符串截取，可数开区间
    ///
    ///     "helloworld"[0..<4] -> "hell"
    ///
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
     }

}
