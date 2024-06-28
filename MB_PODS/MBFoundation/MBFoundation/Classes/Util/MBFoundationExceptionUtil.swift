//
//  MBFoundationExceptionUtil.swift
//  MBFoundation
//
//  Created by 别施轩 on 2021/9/3.
//

import Foundation

@objc public enum MBFoundationLogLevel: Int {
    case debug
    case info
    case warning
    case error
    case fatal
    var intValue:Int? {
        switch self {
        case .debug:
            return 1
        case .info:
            return 2
        case .warning:
            return 3
        case .error:
            return 4
        case .fatal:
            return 5
        }
    }
}

@objc public protocol MBFoundationExceptionDelegate {
    func caughtException(exception: NSException)
    @objc optional func caughtError(feature: String, tag: String, ext:[String:String])
}

@objc public protocol MBFoundationLogDelegate {
    @objc optional func exportLog(level:MBFoundationLogLevel, message: String, submodule: String, tag: String, file: String, function: String, line: Int)
    @objc optional func exportMetric(metricName: String, mainValue:UInt64, sectionValues:[String:UInt64], tags:[String:String], attrs:[String:String])
}

@objc
public class MBFoundationExceptionUtil: NSObject {
    @objc public static let shared: MBFoundationExceptionUtil = {
        MBFoundationExceptionUtil()
    }()

    private override init() {}

    @objc public weak var delegate: MBFoundationExceptionDelegate?
    @objc public weak var logDelegate: MBFoundationLogDelegate?

    @objc public func report(exception: NSException) {
        delegate?.caughtException(exception: exception)
    }

    @objc public func reportError(feature: String, tag: String, ext:[String:String] = [:]) {
        delegate?.caughtError?(feature: feature, tag: tag, ext: ext)
    }

    @objc public func reportMetric(metricName: String, mainValue:UInt64, sectionValues:[String:UInt64], tags:[String:String] = [:], attrs:[String:String] = [:]) {
        logDelegate?.exportMetric?(metricName: metricName, mainValue: mainValue, sectionValues:sectionValues, tags: tags, attrs: attrs)
    }

    public func debugLog(_ items: Any..., subModule: String = "", tag: String = "", file: String = #fileID, function: String = #function, line: Int = #line) {
        self.log(items, level: .debug, subModule: subModule, tag: tag, file: file, function: function, line: line)
    }

    public func infoLog(_ items: Any..., subModule: String = "", tag: String = "", file: String = #fileID, function: String = #function, line: Int = #line) {
        self.log(items, level: .info, subModule: subModule, tag: tag, file: file, function: function, line: line)
    }

    public func warningLog(_ items: Any..., subModule: String = "", tag: String = "", file: String = #fileID, function: String = #function, line: Int = #line) {
        self.log(items, level: .warning, subModule: subModule, tag: tag, file: file, function: function, line: line)
    }

    public func errorLog(_ items: Any..., subModule: String = "", tag: String = "", file: String = #fileID, function: String = #function, line: Int = #line) {
        self.log(items, level: .error, subModule: subModule, tag: tag, file: file, function: function, line: line)
    }

    public func fatalLog(_ items: Any..., subModule: String = "", tag: String = "", file: String = #fileID, function: String = #function, line: Int = #line) {
        self.log(items, level: .fatal, subModule: subModule, tag: tag, file: file, function: function, line: line)
    }

    public func log(_ items: Any..., level: MBFoundationLogLevel, subModule: String = "", tag: String = "", file: String = #fileID , function: String = #function, line: Int = #line) {
        let formattedItems = items.map({ String(describing:$0) })
        let logStr:String = formattedItems.joined(separator: "")
        logDelegate?.exportLog?(level: level, message: logStr, submodule: subModule, tag: tag, file: file, function: function, line: line)
    }

}
