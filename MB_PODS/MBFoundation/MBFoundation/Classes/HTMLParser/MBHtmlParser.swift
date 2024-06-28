//
//  MBHtmlParser.swift
//  MBFoundation_Example
//
//  Created by weigen on 2021/9/3.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable file_length
public enum TagState: Int {
    case begin = 0
    case end
}

struct MBSearchAdjacentModel {
    var pattern: String?
    var range: NSRange?
}

@objc
public class MBNewHtmlModel: NSObject {
    var tagState: TagState?
    var size: NSInteger?
    var range: NSRange?
    var startIdx: NSInteger?
    @objc public var pattern: String?
    @objc public var pHtml: String?
    @objc public var text: String?
    @objc public var color: String?
    @objc public var link: String?
    @objc public var cModel: AnyObject?
}

@objc
public protocol MBHtmlParserDataSource: NSObjectProtocol {
    // 跳转schema
    @objc optional static func textLinkSchemeRouter(link: String)
    // 修改解析
    @objc optional func handleParse(html: String, fontSize: CGFloat, defaultColor: UIColor, linkBlock: (AnyObject) -> Void) -> NSMutableAttributedString
    // 解析pattern
    @objc optional func handleModel(model: MBNewHtmlModel, responsePattern: String)
    // 添加富文本样式
    @objc optional func handleRechText(attr: NSMutableAttributedString, model: MBNewHtmlModel, range: NSRange, callback: (MBNewHtmlModel) -> Void)
    // 新添加的标签
    @objc optional func extentionTag() -> [String]
}

extension MBHtmlParserDataSource {

}

struct ConstantTags {
    fileprivate static let kFontPattern = "<font.*?</font>"
    fileprivate static let kBoldPattern = "<b.*?</b>"
    fileprivate static let kLinkPattern = "<a.*?</a>"
    fileprivate static let kRouterPattern = "<a href=.*?>"

    fileprivate static let kFontTagColor = "color=(.*?)>"
    fileprivate static let kFontTagSize = "size=(.*?)>"

    fileprivate static let kFontBegin = "<font.*?>"
    fileprivate static let kBoldBegin = "<b.*?>"
    fileprivate static let kATagBegin = "<a href=.*?>"

    fileprivate static let kFontEnd = "</font>"
    fileprivate static let kBoldEnd = "</b>"
    fileprivate static let kATagEnd = "</a>"
    fileprivate static let kSingleQuota = "'"
    fileprivate static let kDoubleQuota = "\""
}

typealias MBTextAction = (UIView, NSAttributedString, NSRange, CGRect) -> Void

@objcMembers
public class MBHtmlParser: NSObject, MBHtmlParserDataSource {

    public static let kLinkColor = "#3070d2"

    weak var dataSource: MBHtmlParserDataSource?

    lazy var stack: [MBNewHtmlModel] = []

    init(dataSource: MBHtmlParserDataSource?) {
        self.dataSource = dataSource
    }

    public class func startParse(_ html: String) -> NSMutableAttributedString {
        return startParse(html, fontSize: 13.0)
    }

    public class func startParse(_ html: String, fontSize: CGFloat) -> NSMutableAttributedString {
        return startParse(html, fontSize: fontSize, defaultColor: nil, linkBlock: nil)
    }

    public class func startParse(_ html: String, fontSize: CGFloat = 13.0, defaultColor: UIColor?) -> NSMutableAttributedString {
        return startParse(html, fontSize: fontSize, defaultColor: defaultColor, linkBlock: nil)
    }

    public class func startParse(_ html: String, fontSize: CGFloat = 13.0, linkBlock: ((Any) -> Void)?) -> NSMutableAttributedString {
        return startParse(html, fontSize: fontSize, defaultColor: nil, linkBlock: linkBlock)
    }

    public class func startParse(_ html: String, fontSize: CGFloat = 13.0, defaultColor: UIColor?, linkBlock: ((Any) -> Void)?) -> NSMutableAttributedString {
        let parse = MBHtmlParser(dataSource: nil)
        parse.dataSource = parse
        return parse.preStartParse(html: html, fontSize: fontSize, defaultColor: defaultColor, linkBlock: linkBlock)
    }
    // 业务方调用 内部判断是否实现协议
    @nonobjc
    public func preStartParse(html: String, fontSize: CGFloat, defaultColor: UIColor?, linkBlock: ((Any) -> Void)?) -> NSMutableAttributedString {

        let defaultBlock = {(_: AnyObject) -> Void in

        }
        if let source = dataSource, (source as AnyObject).responds(to: #selector(source.handleParse(html:fontSize:defaultColor:linkBlock:))) {
            return source.handleParse!(html: html, fontSize: fontSize, defaultColor: defaultColor ?? .clear, linkBlock: linkBlock ??  defaultBlock)
        } else {
            return startParse(html: html, fontSize: fontSize, defaultColor: defaultColor) {[weak self] model in
                if let link = model.link, !link.isEmpty {
                    if let block = linkBlock {
                        block(link)
                    } else {
                        guard let source = self?.dataSource else { return }
                        type(of: source).textLinkSchemeRouter?(link: model.link ?? "")
                    }
                }
            }
        }
    }
    // 执行具体的解析
    public func startParse(html: String, fontSize: CGFloat, defaultColor: UIColor?, block:((MBNewHtmlModel) -> Void)?) -> NSMutableAttributedString {
        let text = filterAllTag(html: html)
        let mutableAttr = NSMutableAttributedString(string: text)
        mutableAttr.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: NSRange(location: 0, length: NSString(string: text).length))
        if let color = defaultColor {
            mutableAttr.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: NSString(string: text).length))
        }

        let defaultBlock = {(_: MBNewHtmlModel) -> Void in

        }

        doParse(pHtml: html, pureText: text, attr: mutableAttr, fontSize: fontSize, block: block ?? defaultBlock)
        return mutableAttr
    }

    // 执行解析
    // 1、text
    // 2、text+<font color="cccccc">text</font>
    // 3、text+<font color="cccccc">text</font>+text+<a link="aaa">text</a>
    // 4、<font color="cccccc">text</font>
    // 5、<font color="cccccc">text<b>text</b></font>
    func doParse(pHtml: String, pureText: String, attr: NSMutableAttributedString, fontSize: CGFloat, block: @escaping  (MBNewHtmlModel) -> Void) {
        guard let nextTag = getPatternModel(pHtml: pHtml, pureText: pureText) else {
            if !pHtml.isEmpty {
                let textTag = MBNewHtmlModel()
                textTag.text = pHtml
                textTag.startIdx = NSString(string: pureText).length - NSString(string: filterAllTag(html: pHtml)).length
                addAttribute(attr: attr, model: textTag, block: block)
            }
            return
        }

        if stack.last != nil {// 栈顶是否有数据
            if nextTag.tagState == .begin {
                stack.append(nextTag)
            } else if let preTag = stack.popLast(), let preTagHtml = preTag.pHtml {
                let pTextHtml = NSString(string: preTagHtml).substring(with: NSRange(location: 0, length: NSString(string: preTagHtml).length - (NSString(string: nextTag.pHtml ?? "").length)))
                preTag.text = filterAllTag(html: pTextHtml)
                addAttribute(attr: attr, model: preTag, block: block)
            }
        } else {
            if nextTag.range?.location != 0 {// text+<font color="cccccc">text</font>
                let textTag = MBNewHtmlModel()
                textTag.text = NSString(string: pHtml).substring(to: nextTag.range?.location ?? 0)
                textTag.startIdx = NSString(string: pureText).length - NSString(string: filterAllTag(html: pHtml)).length
                addAttribute(attr: attr, model: textTag, block: block)
            }
            stack.append(nextTag) // 压栈
        }
        let pureHtml = NSString(string: pHtml).substring(from: (nextTag.range?.location ?? 0) + (nextTag.range?.length ?? 0))
        doParse(pHtml: pureHtml, pureText: pureText, attr: attr, fontSize: fontSize, block: block)
    }

    // 添加富文本
    func addAttribute(attr: NSMutableAttributedString, model: MBNewHtmlModel, block: @escaping (MBNewHtmlModel) -> Void) {

        guard let pattern = model.pattern else {
            return
        }

        let range = NSRange(location: model.startIdx ?? 0, length: model.text?.count ?? 0)

        defer {
            // 业务方处理
            dataSource?.handleRechText?(attr: attr, model: model, range: range, callback: block)
        }

        // font
        if pattern == ConstantTags.kFontBegin {
            if let color = model.color, !color.isEmpty {
                attr.addAttribute(.foregroundColor, value: MBHtmlUtil.colorWithHexString(model.color ?? ""), range: range)
            }
            // <font color="" size=""><b></b><font>
            guard let size = model.size, size > 0 else {
                return
            }
            attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { value, range, _ in
                if let font = value as? UIFont {
                    let fontAttr = font.fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")]
                    var fontValue = UIFont.systemFont(ofSize: CGFloat(model.size ?? 13))
                    if let fontName = fontAttr as? String, fontName == "CTFontEmphasizedUsage" {
                        fontValue = UIFont.boldSystemFont(ofSize: CGFloat(model.size ?? 13))
                    }
                    attr.addAttribute(.font, value: fontValue, range: range)
                }
            }

        } else if pattern == ConstantTags.kATagBegin {
            // <a .*?>
            attr.mb_setTextHighlight(range: range, color: MBHtmlUtil.colorWithHexString(model.color ?? ""), background: UIColor.clear) { _, _, _, _ in
                block(model)
            }

        } else if pattern == ConstantTags.kBoldBegin {
            // <b><font color="" size=""><font></b>
            attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { value, range, _ in
                if let font = value as? UIFont {
                    attr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: font.pointSize), range: range)
                }
            }

        }
    }

    // 解析html，返回model
    func getPatternModel(pHtml: String, pureText: String) -> MBNewHtmlModel? {
        let rangeArray = matchAllTags(pHtml: pHtml)
        if rangeArray.isEmpty {
            return nil
        }
        // 排序，取出最小值
        let sortArray = sortSearchAdjacentArray(rangeArray: rangeArray)
        let searchModel = sortArray.first
        let responsePattern = NSString(string: pHtml).substring(with: searchModel?.range ?? NSRange(location: 0, length: 0))
        let htmlModel = MBNewHtmlModel()
        htmlModel.range = searchModel?.range
        htmlModel.pattern = searchModel?.pattern
        htmlModel.pHtml = NSString(string: pHtml).substring(from: (searchModel?.range?.location ?? 0) + (searchModel?.range?.length ?? 0))
        htmlModel.text = responsePattern
        htmlModel.startIdx = NSString(string: pureText).length - NSString(string: filterAllTag(html: htmlModel.pHtml ?? "")).length

        guard let pattern = searchModel?.pattern else {
            return nil
        }

        if pattern == ConstantTags.kFontBegin {
            let filterArray = [ConstantTags.kSingleQuota, ConstantTags.kDoubleQuota]

            if let colorFilter = MBHtmlUtil.regular(content: responsePattern, pattern: ConstantTags.kFontTagColor) {
                if !colorFilter.isEmpty {
                    // 过滤 ""双引号 '(单引号)
                    let color = filterString(string: colorFilter, filterArray: filterArray)
                    htmlModel.color = NSString(string: color).substring(with: NSRange(location: 6, length: 7))
                }
            }

            if let sizeFilter = MBHtmlUtil.regular(content: responsePattern, pattern: ConstantTags.kFontTagSize) {
                if !sizeFilter.isEmpty {
                    // 过滤 ""双引号 '(单引号)
                    let size = filterString(string: sizeFilter, filterArray: filterArray)
                    if let sizeInt = Int(NSString(string: size).substring(with: NSRange(location: 5, length: size.count - 6))) {
                        htmlModel.size = sizeInt
                    }
                }
            }
        }

        if pattern == ConstantTags.kATagBegin {
            htmlModel.color = MBHtmlParser.kLinkColor
            htmlModel.link = NSString(string: responsePattern).substring(with: NSRange(location: 9, length: responsePattern.count - 11))
        }

        htmlModel.tagState = pattern.contains("/") ? .end : .begin

        dataSource?.handleModel?(model: htmlModel, responsePattern: responsePattern)

        return htmlModel
    }

    // 所有标签
    func allTags() -> [String] {
        var tagArray = [ConstantTags.kFontBegin,
                        ConstantTags.kBoldBegin,
                        ConstantTags.kATagBegin,
                        ConstantTags.kFontEnd,
                        ConstantTags.kBoldEnd,
                        ConstantTags.kATagEnd]
        if let extention = dataSource?.extentionTag?() {
            for item in extention {
                tagArray.append(item)
            }
        }
        return tagArray
    }

    // 过滤所有标签
    func filterAllTag(html: String) -> String {
        var text = html
        let patterns = allTags()
        for item in patterns {
            text = MBHtmlUtil.filterRegular(content: text, pattern: item)
        }
        return text
    }

    // 匹配所有的标签
    func matchAllTags(pHtml: String) -> [MBSearchAdjacentModel] {
        let patterns = allTags()
        var rangeArray:[MBSearchAdjacentModel] = []
        for item in patterns {
            let range = MBHtmlUtil.rangeRegular(content: pHtml, pattern: item)
            if range.length > 0 {
                var tagModel = MBSearchAdjacentModel()
                tagModel.range = range
                tagModel.pattern = item
                rangeArray.append(tagModel)
            }
        }
        return rangeArray
    }

    // 从小到大排序
    func sortSearchAdjacentArray(rangeArray: [MBSearchAdjacentModel]) -> [MBSearchAdjacentModel] {
        return rangeArray.sorted { m1, m2 in
            if let loc1 = m1.range?.location, let loc2 = m2.range?.location {
                return loc1 < loc2
            } else {
                return false
            }
        }
    }

    // 过滤字符集
    func filterString(string: String, filterArray: [String]) -> String {
        var result = string
        for filter in filterArray {
            result = result.replacingOccurrences(of: filter, with: "")
        }
        return result
    }

}

@objcMembers
public class MBTextShadow: NSObject {

    public var color: UIColor?
    public var offset: CGSize?
    public var radius: CGFloat?
    public var blendMode: CGBlendMode?
    public var subShadow: MBTextShadow?

}

@objcMembers
public class MBTextBorder: NSObject, NSCopying, NSSecureCoding {
    public var lineStyle: Int
    public var strokeWidth: CGFloat?
    public var strokeColor: UIColor?
    public var lineJoin: CGLineJoin?
    public var insets: UIEdgeInsets
    public var cornerRadius: CGFloat
    public var shadow: MBTextShadow?
    public var fillColor: UIColor

    init(lineStyle: Int, insets: UIEdgeInsets, cornerRadius: CGFloat, fillColor: UIColor) {
        self.lineStyle = lineStyle
        self.insets = insets
        self.cornerRadius = cornerRadius
        self.fillColor = fillColor
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let one = MBTextBorder(lineStyle: lineStyle, insets: insets, cornerRadius: cornerRadius, fillColor: fillColor)
        return one
    }

    public static var supportsSecureCoding: Bool {
        return true
    }

    public func encode(with coder: NSCoder) {
        coder.encode(lineStyle, forKey: "lineStyle")
        coder.encode(insets, forKey: "insets")
        coder.encode(cornerRadius, forKey: "cornerRadius")
        coder.encode(fillColor, forKey: "fillColor")
    }

    required public init?(coder: NSCoder) {
        lineStyle = coder.decodeInteger(forKey: "lineStyle")
        insets = coder.decodeUIEdgeInsets(forKey: "insets")
        cornerRadius = CGFloat(coder.decodeFloat(forKey: "cornerRadius"))
        fillColor = coder.decodeObject(of: UIColor.self, forKey: "fillColor")! as UIColor
    }

}

@objcMembers
class MBTextHighlight: NSObject, NSCopying {

    public var attributes: NSMutableDictionary?

    public var tapAction: MBTextAction?

    required override init() {
        super.init()
    }

    public class func highlightWithBackgroundColor(color: UIColor) -> MBTextHighlight {
        let insets = UIEdgeInsets(top: -2, left: -1, bottom: -2, right: -1)
        let highlightBorder = MBTextBorder(lineStyle: 0x01, insets: insets, cornerRadius: 3, fillColor: color)
        let one = MBTextHighlight()
        one.setBackgroundBorder(border: highlightBorder)
        return one
    }

    func setAttrbute(attributes: NSMutableDictionary) {
        self.attributes = attributes.mutableCopy() as? NSMutableDictionary
    }

    func setBackgroundBorder(border: MBTextBorder?) {
        setTextAttrbute(attribute: "YYTextBackgroundBorder", value: border)
    }

    private func makeMutableAttributes() {
        if attributes == nil {
            attributes = NSMutableDictionary()
        } else {
            attributes = attributes!.mutableCopy() as? NSMutableDictionary
        }
    }

    func setTextAttrbute(attribute: String, value: AnyObject?) {
        makeMutableAttributes()
        var tempValue: AnyObject = NSNull()
        if value != nil {
            tempValue = value!
        }
        attributes![attribute] = tempValue
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let one = MBTextHighlight()
        one.attributes = attributes?.mutableCopy() as? NSMutableDictionary
        return one
    }
}

extension NSMutableAttributedString {

    func mb_setTextHighlight(range: NSRange, color: UIColor?, background: UIColor, tapAction: @escaping MBTextAction) {
        let highlight = MBTextHighlight.highlightWithBackgroundColor(color: background)
        highlight.tapAction = tapAction

        if let color = color {
            mb_setColor(color: color, range: range)
        }

        mb_setTextHighlight(textHighlight: highlight, range: range)
    }

    private func mb_setColor(color: UIColor, range: NSRange) {
        mb_setAttribute(name: kCTForegroundColorAttributeName as String, value: color.cgColor, range: range)
        mb_setAttribute(name: NSAttributedString.Key.foregroundColor.rawValue, value: color, range: range)
    }

    private func mb_setTextHighlight(textHighlight: MBTextHighlight, range: NSRange) {
        mb_setAttribute(name: "YYTextHighlight", value: textHighlight, range: range)
    }

    private func mb_setAttribute(name: String?, value: AnyObject?, range: NSRange) {
        if name == nil || NSNull.isEqual(name) {
            return
        }

        if let value = value, !NSNull.isEqual(value) {
            addAttribute(NSAttributedString.Key(rawValue: name!), value: value, range: range)
        } else {
            removeAttribute(NSAttributedString.Key(name!), range: range)
        }
    }
}

@objcMembers
public class MBHtmlUtil: NSObject {

    // 返回rang
    public class func rangeRegular(content: String, pattern: String) -> NSRange {

        guard let expression = try? NSRegularExpression(pattern: pattern) else {
            return NSRange(location: 0, length: 0)
        }

        let result = expression.firstMatch(in: content, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: NSString(string: content).length))
        guard let res = result else { return NSRange(location: 0, length: 0) }
        if !(res.range.location == NSNotFound) && res.range.length > 0 {
            return res.range
        } else {
            return NSRange(location: 0, length: 0)
        }
    }

    // 过滤单前标签
    public class func regular(content: String, pattern: String) -> String? {

        guard let expressionType = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let result = expressionType.firstMatch(in: content, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: NSString(string: content).length))

        if result != nil && !(result?.range.location == NSNotFound) && result!.range.length > 0 {
            return NSString(string: content).substring(with: result!.range)
        }

        return nil
    }

    // 过滤所有标签
    public class func filterRegular(content: String, pattern: String) -> String {
        guard let expression = try? NSRegularExpression(pattern: pattern) else {
            return content
        }

        let result = expression.matches(in: content, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: NSString(string: content).length))
        if result.isEmpty {
            return content
        }

        var htmlContent = content
        result.reversed().forEach { item in
            htmlContent = expression.stringByReplacingMatches(in: htmlContent, options: .reportProgress, range: item.range, withTemplate: "")
        }

        htmlContent = htmlContent.replacingOccurrences(of: pattern, with: "")
        return htmlContent
    }

    // 十六进制颜色
    public class func colorWithHexString(_ color: String) -> UIColor {
        var cString = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if cString.count < 6 {
            return UIColor.clear
        }

        var startIndex: String.Index?
        if cString.hasPrefix("0X") {
            startIndex = cString.index(cString.startIndex, offsetBy: 2)
        }

        if cString.hasPrefix("#") {
            startIndex = cString.index(cString.startIndex, offsetBy: 1)
        }

        if startIndex != nil {
            cString = String(cString[startIndex!..<cString.endIndex])
        }

        if cString.count != 6 {
            return UIColor.clear
        }

        // R
        let rEndIndex  = cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[..<rEndIndex])
        // G
        let gEndIndex = cString.index(cString.startIndex, offsetBy: 4)
        let gString = String(cString[rEndIndex..<gEndIndex])
        // B
        let bString = String(cString[gEndIndex..<cString.endIndex])

        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        Scanner.init(string: rString).scanHexInt32(&red)
        Scanner.init(string: gString).scanHexInt32(&green)
        Scanner.init(string: bString).scanHexInt32(&blue)

        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

}
