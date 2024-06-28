// 
//  DateExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

// swiftlint:disable all
/**
 Unicode Date Field Symbol Guide

 Format    Description                              Example
 "y"        1 digit min year                        1, 42, 2017
 "yy"       2 digit year                            01, 42, 17
 "yyy"      3 digit min year                        001, 042, 2017
 "yyyy"     4 digit min year                        0001, 0042, 2017
 "M"        1 digit min month                       7, 12
 "MM"       2 digit month                           07, 12
 "MMM"      3 letter month abbr.                    Jul, Dec
 "MMMM"     Full month                              July, December
 "MMMMM"    1 letter month abbr.                    J, D
 "d"        1 digit min day                         4, 25
 "dd"       2 digit day                             04, 25
 "E", "EE", "EEE"    3 letter day name abbr.        Wed, Thu
 "EEEE"     full day name                           Wednesday, Thursday
 "EEEEE"    1 letter day name abbr.                 W, T
 "EEEEEE"   2 letter day name abbr.                 We, Th
 "a"        Period of day                           AM, PM
 "h"        AM/PM 1 digit min hour                  5, 7
 "hh"       AM/PM 2 digit hour                      05, 07
 "H"        24 hr 1 digit min hour                  17, 7
 "HH"       24 hr 2 digit hour                      17, 07
 "m"        1 digit min minute                      1, 40
 "mm"       2 digit minute                          01, 40
 "s"        1 digit min second                      1, 40
 "ss"       2 digit second                          01, 40
 "S"        10th's place of fractional second       123ms -> 1, 7ms -> 0
 "SS"       10th's & 100th's place of fractional second    123ms -> 12, 7ms -> 00
 "SSS"      10th's & 100th's & 1,000's place of fractional second    123ms -> 123, 7ms -> 007
 */

// MARK: Date

public extension Date {

    // MARK: - Convert from String

    /*
        Creates a new Date based on a string of a specified format. Supports optional timezone and locale.
    */
    init?(fromString string: String, format: DateFormatType, timeZone: TimeZoneType = .local, locale: Locale = Foundation.Locale.current, isLenient: Bool = true) {
        guard !string.isEmpty else {
            return nil
        }
        var string = string
        switch format {
            case .dotNet:
                let pattern = "\\\\?/Date\\((\\d+)(([+-]\\d{2})(\\d{2}))?\\)\\\\?/"
                let regex = try! NSRegularExpression(pattern: pattern)
                guard let match = regex.firstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count)) else {
                    return nil
                }
                let dateString = (string as NSString).substring(with: match.range(at: 1))
                let interval = Double(dateString)! / 1000.0
                self.init(timeIntervalSince1970: interval)
                return
            case .rss, .altRSS:
                if string.hasSuffix("Z") {
                    string = string[..<string.index(string.endIndex, offsetBy: -1)].appending("GMT")
                }
            default:
                break
        }
        let formatter = Date.cachedDateFormatters.cachedFormatter(
            format.stringFormat,
            timeZone: timeZone.timeZone,
            locale: locale,
            isLenient: isLenient)
        guard let date = formatter.date(from: string) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }

    /*
        Creates a new Date based on the first date detected on a string using data dectors.
    */
    init?(detectFromString string: String) {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        let matches = detector?.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        if let date = matches?.first?.date {
            self.init()
            self = date
        } else {
            return nil
        }
    }

    // MARK: - Convert to String

    /// Converts the date to string using the short date and time style.
    func toString(style: DateStyleType = .short) -> String {
        switch style {
        case .short:
            return self.toString(dateStyle: .short, timeStyle: .short, isRelative: false)
        case .medium:
            return self.toString(dateStyle: .medium, timeStyle: .medium, isRelative: false)
        case .long:
            return self.toString(dateStyle: .long, timeStyle: .long, isRelative: false)
        case .full:
            return self.toString(dateStyle: .full, timeStyle: .full, isRelative: false)
        case .ordinalDay:
            let formatter = Date.cachedDateFormatters.cachedNumberFormatter()
            if #available(iOSApplicationExtension 9.0, *) {
                formatter.numberStyle = .ordinal
            }
            return formatter.string(from: component(.day)! as NSNumber)!
        case .weekday:
            let weekdaySymbols = Date.cachedDateFormatters.cachedFormatter().weekdaySymbols!
            let string = weekdaySymbols[component(.weekday)!-1] as String
            return string
        case .shortWeekday:
            let shortWeekdaySymbols = Date.cachedDateFormatters.cachedFormatter().shortWeekdaySymbols!
            return shortWeekdaySymbols[component(.weekday)!-1] as String
        case .veryShortWeekday:
            let veryShortWeekdaySymbols = Date.cachedDateFormatters.cachedFormatter().veryShortWeekdaySymbols!
            return veryShortWeekdaySymbols[component(.weekday)!-1] as String
        case .month:
            let monthSymbols = Date.cachedDateFormatters.cachedFormatter().monthSymbols!
            return monthSymbols[component(.month)!-1] as String
        case .shortMonth:
            let shortMonthSymbols = Date.cachedDateFormatters.cachedFormatter().shortMonthSymbols!
            return shortMonthSymbols[component(.month)!-1] as String
        case .veryShortMonth:
            let veryShortMonthSymbols = Date.cachedDateFormatters.cachedFormatter().veryShortMonthSymbols!
            return veryShortMonthSymbols[component(.month)!-1] as String
        }
    }

    /// Converts the date to string based on a date format, optional timezone and optional locale.
    func toString(format: DateFormatType, timeZone: TimeZoneType = .local, locale: Locale = Locale.current) -> String {
        var useLocale = locale

        switch format {
        case .dotNet:
            let offset = Foundation.NSTimeZone.default.secondsFromGMT() / 3600
            let nowMillis = 1000 * self.timeIntervalSince1970
            return String(format: format.stringFormat, nowMillis, offset)
        case .isoDateTimeMilliSec, .isoDateTimeSec, .isoDateTime,
             .isoYear, . isoDate, .isoYearMonth:
            if #available(iOS 11.0, watchOS 3, tvOS 10, macOS 13, *) {
                return formatIsoDate(format: format, timeZone: timeZone)
            } else {
                useLocale = Locale(identifier: "en_US_POSIX")
            }
        default:
            break
        }
        let formatter = Date.cachedDateFormatters.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone, locale: useLocale)
        return formatter.string(from: self)
    }

    /// Converts to ISO format using the new API
    @available(iOS 11.0, watchOS 3, tvOS 10, macOS 13, *)
    func formatIsoDate(format: DateFormatType, timeZone: TimeZoneType = .local) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone.timeZone

        var options: ISO8601DateFormatter.Options = []
        switch format {
        case .isoDate:
            options = [.withFullDate]
        case .isoYearMonth:
            options = [.withYear, .withMonth]
        case .isoYear:
            options = [.withYear]
        case .isoDateTimeSec, .isoDateTime:
            options = [.withInternetDateTime]
        case .isoDateTimeMilliSec:
            options = [.withInternetDateTime, .withFractionalSeconds]
        default:
            fatalError("Unimplemented format \(format)")
        }

        formatter.formatOptions = options
        return formatter.string(from: self)
    }

    /// Converts the date to string based on DateFormatter's date style and time style with optional relative date formatting, optional time zone and optional locale.
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, isRelative: Bool = false, timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local, locale: Locale = Locale.current) -> String {
        let formatter = Date.cachedDateFormatters.cachedFormatter(dateStyle, timeStyle: timeStyle, doesRelativeDateFormatting: isRelative, timeZone: timeZone, locale: locale)
        return formatter.string(from: self)
    }

    /// Converts the date to string based on a relative time language. i.e. just now, 1 minute ago etc...
    func toStringWithRelativeTime(strings: [RelativeTimeStringType: String]? = nil) -> String {
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970

        let sec: Double = abs(now - time)
        let min: Double = round(sec/60)
        let hr: Double = round(min/60)
        let d: Double = round(hr/24)

        switch toRelativeTime() {
        case .nowPast:
            return strings?[.nowPast] ?? NSLocalizedString("just now", comment: "Date format")
        case .nowFuture:
            return strings?[.nowFuture] ?? NSLocalizedString("in a few seconds", comment: "Date format")
        case .secondsPast:
            return String(
                format: strings?[.secondsPast] ?? NSLocalizedString("%.f seconds ago", comment: "Date format"),
                sec
            )
        case .secondsFuture:
            return String(
                format: strings?[.secondsFuture] ?? NSLocalizedString("in %.f seconds", comment: "Date format"),
                sec
            )
        case .oneMinutePast:
            return strings?[.oneMinutePast] ?? NSLocalizedString("1 minute ago", comment: "Date format")
        case .oneMinuteFuture:
            return strings?[.oneMinuteFuture] ?? NSLocalizedString("in 1 minute", comment: "Date format")
        case .minutesPast:
            return String(
                format: strings?[.minutesPast] ?? NSLocalizedString("%.f minutes ago", comment: "Date format"),
                min
            )
        case .minutesFuture:
            return String(
                format: strings?[.minutesFuture] ?? NSLocalizedString("in %.f minutes", comment: "Date format"),
                min
            )
        case .oneHourPast:
            return strings?[.oneHourPast] ?? NSLocalizedString("last hour", comment: "Date format")
        case .oneHourFuture:
            return strings?[.oneHourFuture] ?? NSLocalizedString("next hour", comment: "Date format")
        case .hoursPast:
            return String(
                format: strings?[.hoursPast] ?? NSLocalizedString("%.f hours ago", comment: "Date format"),
                hr
            )
        case .hoursFuture:
            return String(
                format: strings?[.hoursFuture] ?? NSLocalizedString("in %.f hours", comment: "Date format"),
                hr
            )
        case .oneDayPast:
            return strings?[.oneDayPast] ?? NSLocalizedString("yesterday", comment: "Date format")
        case .oneDayFuture:
            return strings?[.oneDayFuture] ?? NSLocalizedString("tomorrow", comment: "Date format")
        case .daysPast:
            return String(
                format: strings?[.daysPast] ?? NSLocalizedString("%.f days ago", comment: "Date format"),
                d
            )
        case .daysFuture:
            return String(
                format: strings?[.daysFuture] ?? NSLocalizedString("in %.f days", comment: "Date format"),
                d
            )
        case .oneWeekPast:
            return strings?[.oneWeekPast] ?? NSLocalizedString("last week", comment: "Date format")
        case .oneWeekFuture:
            return strings?[.oneWeekFuture] ?? NSLocalizedString("next week", comment: "Date format")
        case .weeksPast:
            let string = strings?[.weeksPast] ?? NSLocalizedString("%.f weeks ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .week))))
        case .weeksFuture:
            let string = strings?[.weeksFuture] ?? NSLocalizedString("in %.f weeks", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .week))))
        case .oneMonthPast:
            return strings?[.oneMonthPast] ?? NSLocalizedString("last month", comment: "Date format")
        case .oneMonthFuture:
            return strings?[.oneMonthFuture] ?? NSLocalizedString("next month", comment: "Date format")
        case .monthsPast:
            let string = strings?[.monthsPast] ?? NSLocalizedString("%.f months ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .month))))
        case .monthsFuture:
            let string = strings?[.monthsFuture] ?? NSLocalizedString("in %.f months", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .month))))
        case .oneYearPast:
            return strings?[.oneYearPast] ?? NSLocalizedString("last year", comment: "Date format")
        case .oneYearFuture:
            return strings?[.oneYearFuture] ?? NSLocalizedString("next year", comment: "Date format")
        case .yearsPast:
            let string = strings?[.yearsPast] ?? NSLocalizedString("%.f years ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .year))))
        case .yearsFuture:
            let string = strings?[.yearsFuture] ?? NSLocalizedString("in %.f years", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .year))))
        }
    }

    /// Converts the date to  a relative time language. i.e. .nowPast, .minutesFuture
    func toRelativeTime() -> RelativeTimeStringType {
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        let isPast = now - time > 0

        let sec: Double = abs(now - time)
        let min: Double = round(sec/60)
        let hr: Double = round(min/60)
        let d: Double = round(hr/24)

        if sec < 60 {
            if sec < 10 {
                if isPast {
                    return .nowPast
                } else {
                    return .nowFuture
                }
            } else {
                if isPast {
                    return .secondsPast
                } else {
                    return .secondsFuture
                }
            }
        }
        if min < 60 {
            if min == 1 {
                if isPast {
                    return .oneMinutePast
                } else {
                    return .oneMinuteFuture
                }
            } else {
                if isPast {
                    return .minutesPast
                } else {
                    return .minutesFuture
                }
            }
        }
        if hr < 24 {
            if hr == 1 {
                if isPast {
                    return .oneHourPast
                } else {
                    return .oneHourFuture
                }
            } else {
                if isPast {
                    return .hoursPast
                } else {
                    return .hoursFuture
                }
            }
        }
        if d < 7 {
            if d == 1 {
                if isPast {
                    return .oneDayPast
                } else {
                    return .oneDayFuture
                }
            } else {
                if isPast {
                    return .daysPast
                } else {
                    return .daysFuture
                }
            }
        }
        if d < 28 {
            if isPast {
                if compare(.isLastWeek) {
                    return .oneWeekPast
                } else {
                    return .weeksPast
                }
            } else {
                if compare(.isNextWeek) {
                    return .oneWeekFuture
                } else {
                    return .weeksFuture
                }
            }
        }
        if compare(.isThisYear) {
            if isPast {
                if compare(.isLastMonth) {
                    return .oneMonthPast
                } else {
                    return .monthsPast
                }
            } else {
                if compare(.isNextMonth) {
                    return .oneMonthFuture
                } else {
                    return .monthsFuture
                }
            }
        }
        if isPast {
            if compare(.isLastYear) {
                return .oneYearPast
            } else {
                return .yearsPast
            }
        } else {
            if compare(.isNextYear) {
                return .oneYearFuture
            } else {
                return .yearsFuture
            }
        }
    }

    // MARK: - Compare Dates

    /// Compares dates to see if they are equal while ignoring time.
    func compare(_ comparison: DateComparisonType) -> Bool {
        switch comparison {
            case .isToday:
                return compare(.isSameDay(as: Date()))
            case .isTomorrow:
                let comparison = Date().adjust(.day, offset: 1)
                return compare(.isSameDay(as: comparison))
            case .isYesterday:
                let comparison = Date().adjust(.day, offset: -1)
                return compare(.isSameDay(as: comparison))
            case .isSameDay(let date): 
                guard let date = date else {
                    return false
                }
                return component(.year) == date.component(.year)
                    && component(.month) == date.component(.month)
                    && component(.day) == date.component(.day)
            case .isThisWeek:
                return self.compare(.isSameWeek(as: Date()))
            case .isNextWeek:
                let comparison = Date().adjust(.week, offset: 1)
                return compare(.isSameWeek(as: comparison))
            case .isLastWeek:
                let comparison = Date().adjust(.week, offset: -1)
                return compare(.isSameWeek(as: comparison))
            case .isSameWeek(let date):
                guard let date = date else {
                    return false
                }
                if component(.week) != date.component(.week) {
                    return false
                }
                // Ensure time interval is under 1 week
                return abs(self.timeIntervalSince(date)) < Date.weekInSeconds
            case .isThisMonth:
                return self.compare(.isSameMonth(as: Date()))
            case .isNextMonth:
                let comparison = Date().adjust(.month, offset: 1)
                return compare(.isSameMonth(as: comparison))
            case .isLastMonth:
                let comparison = Date().adjust(.month, offset: -1)
                return compare(.isSameMonth(as: comparison))
            case .isSameMonth(let date):
                guard let date = date else {
                    return false
                }
                return component(.year) == date.component(.year) && component(.month) == date.component(.month)
            case .isThisYear:
                return self.compare(.isSameYear(as: Date()))
            case .isNextYear:
                let comparison = Date().adjust(.year, offset: 1)
                return compare(.isSameYear(as: comparison))
            case .isLastYear:
                let comparison = Date().adjust(.year, offset: -1)
                return compare(.isSameYear(as: comparison))
            case .isSameYear(let date):
                guard let date = date else {
                    return false
                }
                return component(.year) == date.component(.year)
            case .isInTheFuture:
                return self.compare(.isLater(than: Date()))
            case .isInThePast:
                return self.compare(.isEarlier(than: Date()))
            case .isEarlier(let date):
                guard let date = date else {
                    return false
                }
                return (self as NSDate).earlierDate(date) == self
            case .isLater(let date):
                guard let date = date else {
                    return false
                }
                return (self as NSDate).laterDate(date) == self
            case .isWeekday:
                return !compare(.isWeekend)
            case .isWeekend:
                let range = Calendar.current.maximumRange(of: Calendar.Component.weekday)!
                return (component(.weekday) == range.lowerBound || component(.weekday) == range.upperBound - range.lowerBound)
        }

    }

    // MARK: - Adjust dates

    /// Creates a new date with adjusted components

    func adjust(_ component: DateComponentType, offset: Int) -> Date {
        var dateComp = DateComponents()
        switch component {
            case .second:
                dateComp.second = offset
            case .minute:
                dateComp.minute = offset
            case .hour:
                dateComp.hour = offset
            case .day:
                dateComp.day = offset
            case .weekday:
                dateComp.weekday = offset
            case .nthWeekday:
                dateComp.weekdayOrdinal = offset
            case .week:
                dateComp.weekOfYear = offset
            case .month:
                dateComp.month = offset
            case .year:
                dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }

    /// Return a new Date object with the new hour, minute and seconds values.
    func adjust(hour: Int?, minute: Int?, second: Int?, day: Int? = nil, month: Int? = nil) -> Date {
        var comp = Date.components(self)
        comp.month = month ?? comp.month
        comp.day = day ?? comp.day
        comp.hour = hour ?? comp.hour
        comp.minute = minute ?? comp.minute
        comp.second = second ?? comp.second
        return Calendar.current.date(from: comp)!
    }

    // MARK: - Date for...

    func dateFor(_ type: DateForType, calendar: Calendar = Calendar.current) -> Date {
        switch type {
        case .startOfDay:
            return adjust(hour: 0, minute: 0, second: 0)
        case .endOfDay:
            return adjust(hour: 23, minute: 59, second: 59)
        case .startOfWeek:
            return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        case .endOfWeek:
            let offset = 7 - component(.weekday)!
            return adjust(.day, offset: offset)
        case .startOfMonth:
            return adjust(hour: 0, minute: 0, second: 0, day: 1)
        case .endOfMonth:
            let month = (component(.month) ?? 0) + 1
            return adjust(hour: 0, minute: 0, second: 0, day: 0, month: month)
        case .tomorrow:
            return adjust(.day, offset: 1)
        case .yesterday:
            return adjust(.day, offset: -1)
        case .nearestMinute(let nearest):
            let minutes = (component(.minute)! + nearest/2) / nearest * nearest
            return adjust(hour: nil, minute: minutes, second: nil)
        case .nearestHour(let nearest):
            let hours = (component(.hour)! + nearest/2) / nearest * nearest
            return adjust(hour: hours, minute: 0, second: nil)
        }
    }

    // MARK: - Time since...

    func since(_ date: Date, in component: DateComponentType) -> Int64 {
        let calendar = MBDateFormatterManager.sharedCalendar as Calendar?
        guard let calendar = calendar else { return 0 }
        switch component {
        case .second:
            return Int64(timeIntervalSince(date))
        case .minute:
            let interval = timeIntervalSince(date)
            return Int64(interval / Date.minuteInSeconds)
        case .hour:
            let interval = timeIntervalSince(date)
            return Int64(interval / Date.hourInSeconds)
        case .day:
            if let day = calendar.dateComponents([.day], from: date, to: self).day {
                return Int64(day)
            }
            return 0
        case .weekday:
            let end = calendar.ordinality(of: .weekday, in: .era, for: self)
            let start = calendar.ordinality(of: .weekday, in: .era, for: date)
            return Int64(end! - start!)
        case .nthWeekday:
            let end = calendar.ordinality(of: .weekdayOrdinal, in: .era, for: self)
            let start = calendar.ordinality(of: .weekdayOrdinal, in: .era, for: date)
            return Int64(end! - start!)
        case .week:
            if let day = calendar.dateComponents([.day], from: date, to: self).day {
                return Int64(ceil(Double(day) / 7.0))
            }
            return 0
        case .month:
            if let month = calendar.dateComponents([.month], from: date, to: self).month {
                return Int64(month)
            }
            return 0
        case .year:
            if let year = calendar.dateComponents([.year], from: date, to: self).year {
                return Int64(year)
            }
            return 0
        }
    }

    // MARK: - Extracting components

    func component(_ component: DateComponentType) -> Int? {
        let components = Date.components(self)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .nthWeekday:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }

    func numberOfDaysInMonth() -> Int {
        let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)!
        return range.upperBound - range.lowerBound
    }

    func firstDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }

    func lastDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let distanceToEndOfWeek = Date.dayInSeconds * Double(7)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }

    // MARK: - Internal Components

    internal static func componentFlags() -> Set<Calendar.Component> { return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear] }
    internal static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }

    internal class concurrentFormatterCache {
        private static let cachedDateFormattersQueue = DispatchQueue(
            label: "date-formatter-queue",
            attributes: .concurrent
        )

        private static let cachedNumberFormatterQueue = DispatchQueue(
            label: "number-formatter-queue",
            attributes: .concurrent
        )

        private static var cachedDateFormatters = [String: DateFormatter]()
        private static var cachedNumberFormatter = NumberFormatter()

        private func register(hashKey: String, formatter: DateFormatter) {
            concurrentFormatterCache.cachedDateFormattersQueue.async(flags: .barrier) {
                concurrentFormatterCache.cachedDateFormatters.updateValue(formatter, forKey: hashKey)
            }

        }

        private func retrieve(hashKey: String) -> DateFormatter? {
            let dateFormatter = concurrentFormatterCache.cachedDateFormattersQueue.sync { () -> DateFormatter? in
                guard let result = concurrentFormatterCache.cachedDateFormatters[hashKey] else { return nil }

                return result.copy() as? DateFormatter
            }

            return dateFormatter
        }

        private func retrieve() -> NumberFormatter {
            let numberFormatter = concurrentFormatterCache.cachedNumberFormatterQueue.sync { () -> NumberFormatter in

                // Should always be NumberFormatter
                return concurrentFormatterCache.cachedNumberFormatter.copy() as! NumberFormatter
            }

            return numberFormatter
        }

        public func cachedFormatter(_ format: String = DateFormatType.standard.stringFormat,
                                    timeZone: Foundation.TimeZone = Foundation.TimeZone.current,
                                    locale: Locale = Locale.current, isLenient: Bool = true) -> DateFormatter {

                let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"

                if Date.cachedDateFormatters.retrieve(hashKey: hashKey) == nil {
                    let formatter = DateFormatter()
                    formatter.dateFormat = format
                    formatter.timeZone = timeZone
                    formatter.locale = locale
                    formatter.isLenient = isLenient
                    Date.cachedDateFormatters.register(hashKey: hashKey, formatter: formatter)
                }

                return Date.cachedDateFormatters.retrieve(hashKey: hashKey)!
        }

        /// Generates a cached formatter based on the provided date style, time style and relative date.
        /// Formatters are cached in a singleton array using hashkeys.
        public func cachedFormatter(_ dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool, timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local, locale: Locale = Locale.current, isLenient: Bool = true) -> DateFormatter {
            let hashKey = "\(dateStyle.hashValue)\(timeStyle.hashValue)\(doesRelativeDateFormatting.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
            if Date.cachedDateFormatters.retrieve(hashKey: hashKey) == nil {
                let formatter = DateFormatter()
                formatter.dateStyle = dateStyle
                formatter.timeStyle = timeStyle
                formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
                formatter.timeZone = timeZone
                formatter.locale = locale
                formatter.isLenient = isLenient
                Date.cachedDateFormatters.register(hashKey: hashKey, formatter: formatter)
            }

            return Date.cachedDateFormatters.retrieve(hashKey: hashKey)!
        }

        public func cachedNumberFormatter() -> NumberFormatter {
            return Date.cachedDateFormatters.retrieve()
        }

    }

    /// A cached static array of DateFormatters so that thy are only created once.
    private static var cachedDateFormatters = concurrentFormatterCache()

    // MARK: - Intervals In Seconds
    internal static let minuteInSeconds: Double = 60
    internal static let hourInSeconds: Double = 3600
    internal static let dayInSeconds: Double = 86400
    internal static let weekInSeconds: Double = 604800
    internal static let yearInSeconds: Double = 31556926

}

// MARK: - Enums used
/**
 The string format used for date string conversion.
 
 ````
 case isoYear: i.e. 1997
 case isoYearMonth: i.e. 1997-07
 case isoDate: i.e. 1997-07-16
 case isoDateTime: i.e. 1997-07-16T19:20+01:00
 case isoDateTimeSec: i.e. 1997-07-16T19:20:30+01:00
 case isoDateTimeMilliSec: i.e. 1997-07-16T19:20:30.45+01:00
 case dotNet: i.e. "/Date(1268123281843)/"
 case rss: i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
 case altRSS: i.e. "09 Sep 2011 15:26:08 +0200"
 case httpHeader: i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
 case standard: "EEE MMM dd HH:mm:ss Z yyyy"
 case custom(String): a custom date format string
 ````
 
 */
public enum DateFormatType {

    /// The ISO8601 formatted year "yyyy" i.e. 1997
    case isoYear

    /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
    case isoYearMonth

    /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
    case isoDate

    /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
    case isoDateTime

    /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
    case isoDateTimeSec

    /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
    case isoDateTimeMilliSec

    /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
    case dotNet

    /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
    case rss

    /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
    case altRSS

    /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
    case httpHeader

    /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
    case standard

    /// A custom date format string
    case custom(String)

    var stringFormat: String {
        switch self {
        case .isoYear: return "yyyy"
        case .isoYearMonth: return "yyyy-MM"
        case .isoDate: return "yyyy-MM-dd"
        case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
        case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .dotNet: return "/Date(%d%f)/"
        case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
        case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
        case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
        case .custom(let customFormat): return customFormat
        }
    }
}

extension DateFormatType: Equatable {
    public static func ==(lhs: DateFormatType, rhs: DateFormatType) -> Bool {
        switch (lhs, rhs) {
        case (.custom(let lhsString), .custom(let rhsString)):
            return lhsString == rhsString
        default:
            return lhs == rhs
        }
    }
}

/// The time zone to be used for date conversion
public enum TimeZoneType {
    case local, `default`, utc, custom(Int)
    var timeZone: TimeZone {
        switch self {
        case .local: return NSTimeZone.local
        case .default: return NSTimeZone.default
        case .utc: return TimeZone(secondsFromGMT: 0)!
        case let .custom(gmt): return TimeZone(secondsFromGMT: gmt)!
        }
    }
}

// The string keys to modify the strings in relative format
public enum RelativeTimeStringType {
    case nowPast, nowFuture, secondsPast, secondsFuture, oneMinutePast, oneMinuteFuture, minutesPast, minutesFuture, oneHourPast, oneHourFuture, hoursPast, hoursFuture, oneDayPast, oneDayFuture, daysPast, daysFuture, oneWeekPast, oneWeekFuture, weeksPast, weeksFuture, oneMonthPast, oneMonthFuture, monthsPast, monthsFuture, oneYearPast, oneYearFuture, yearsPast, yearsFuture
}

// The type of comparison to do against today's date or with the suplied date.
public enum DateComparisonType {

    // Days

    /// Checks if date today.
    case isToday
    /// Checks if date is tomorrow.
    case isTomorrow
    /// Checks if date is yesterday.
    case isYesterday
    /// Compares date days
    case isSameDay(as: Date?)

    // Weeks

    /// Checks if date is in this week.
    case isThisWeek
    /// Checks if date is in next week.
    case isNextWeek
    /// Checks if date is in last week.
    case isLastWeek
    /// Compares date weeks
    case isSameWeek(as: Date?)

    // Months

    /// Checks if date is in this month.
    case isThisMonth
    /// Checks if date is in next month.
    case isNextMonth
    /// Checks if date is in last month.
    case isLastMonth
    /// Compares date months
    case isSameMonth(as: Date?)

    // Years

    /// Checks if date is in this year.
    case isThisYear
    /// Checks if date is in next year.
    case isNextYear
    /// Checks if date is in last year.
    case isLastYear
    /// Compare date years
    case isSameYear(as: Date?)

    // Relative Time

    /// Checks if it's a future date
    case isInTheFuture
    /// Checks if the date has passed
    case isInThePast
    /// Checks if earlier than date
    case isEarlier(than: Date?)
    /// Checks if later than date
    case isLater(than: Date?)
    /// Checks if it's a weekday
    case isWeekday
    /// Checks if it's a weekend
    case isWeekend

}

// The date components available to be retrieved or modifed
public enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}

// The type of date that can be used for the dateFor function.
public enum DateForType {
    case startOfDay, endOfDay, startOfWeek, endOfWeek, startOfMonth, endOfMonth, tomorrow, yesterday, nearestMinute(minute: Int), nearestHour(hour: Int)
}

// Convenience types for date to string conversion
public enum DateStyleType {
    /// Short style: "2/27/17, 2:22 PM"
    case short
    /// Medium style: "Feb 27, 2017, 2:22:06 PM"
    case medium
    /// Long style: "February 27, 2017 at 2:22:06 PM EST"
    case long
    /// Full style: "Monday, February 27, 2017 at 2:22:06 PM Eastern Standard Time"
    case full
    /// Ordinal day: "27th"
    case ordinalDay
    /// Weekday: "Monday"
    case weekday
    /// Short week day: "Mon"
    case shortWeekday
    /// Very short weekday: "M"
    case veryShortWeekday
    /// Month: "February"
    case month
    /// Short month: "Feb"
    case shortMonth
    /// Very short month: "F"
    case veryShortMonth
}

// MARK: NSDate
@objc
public extension NSDate {

//    #define DATE_FORMAT_year @"yyyy"
//    #define DATE_FORMAT_Month @"yyyy-MM"
//    #define DATE_FORMAT_day @"yyyy-MM-dd"
//    #define DATE_FORMAT_Hour @"yyyy-MM-dd HH"
//    #define DATE_FORMAT_minute @"yyyy-MM-dd HH:mm"
//    #define DATE_FORMAT_second @"yyyy-MM-dd HH:mm:ss"
//    #define DATE_FORMAT_second_SSS @"yyyy-MM-dd HH:mm:ss.SSS"
//    #define DATE_FORMAT_zzzz @"yyyy-MM-dd HH:mm:ss zzzz"
//
//    #define DATE_FORMAT_sMM @"MM-dd HH:mm"
//
//    #define DATE_Diff_Year @"yyyy"
//    #define DATE_Diff_Month @"MM"
//    #define DATE_Diff_Day @"dd"
//    #define DATE_Diff_Hour @"HH"
//    #define DATE_Diff_Minute @"mm"
//    #define DATE_Diff_Second @"ss"

//    #define D_MINUTE    60
//    #define D_HOUR        3600
//    #define D_DAY        86400
//    #define D_WEEK        604800
//    #define D_YEAR        31556926

    static func mb_dateFormatYear() -> NSString {
        "yyyy"
    }

    static func mb_dateFormatMonth() -> NSString {
        "yyyy-MM"
    }

    static func mb_dateFormatDay() -> NSString {
        "yyyy-MM-dd"
    }

    static func mb_dateFormatHour() -> NSString {
        "yyyy-MM-dd HH"
    }

    static func mb_dateFormatMinute() -> NSString {
        "yyyy-MM-dd HH:mm"
    }

    static func mb_dateFormatSecond() -> NSString {
        "yyyy-MM-dd HH:mm:ss"
    }

    static func mb_dateFormatSecondSSS() -> NSString {
        "yyyy-MM-dd HH:mm:ss.SSS"
    }

    static func mb_dateFormatzzzz() -> NSString {
        "yyyy-MM-dd HH:mm:ss zzzz"
    }

    static func mb_dateFormatsMM() -> NSString {
        "MM-dd HH:mm"
    }

    static func mb_Minute() -> NSInteger {
        60
    }

    static func mb_Hour() -> NSInteger {
        3600
    }

    static func mb_Day() -> NSInteger {
        86400
    }

    static func mb_Week() -> NSInteger {
        604800
    }

    static func mb_Year() -> NSInteger {
        31556926
    }

    // MARK: Format

    convenience init?(withYear year: NSInteger, month: NSInteger, day: NSInteger) {
        if let date = DateComponents(calendar: Calendar.current, year: Int(year), month: Int(month), day: Int(day)).date {
            self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
        } else {
            return nil
        }
    }
    
    static func mb_date(year: NSInteger, month: NSInteger, day: NSInteger, hour: NSString?, minute: NSString?) -> NSDate? {
        guard let hour = hour, let minute = minute else {
            return nil
        }
        let dateStr = NSString.init(format: "%04zd/%02zd/%02zd %@:%@", year, month, day, hour, minute)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let resultDate = dateFormatter.date(from: dateStr as String)
        return resultDate as NSDate?
    }
    
    func mb_floorIntegerDate() -> NSDate? {
        if self.mb_minute > 0 || self.mb_second > 0 {
            let date = (self as Date).adjust(.minute, offset: 1) as NSDate
            let hourStr = NSString.init(format: "%02zd", date.mb_hour)
            let minuteStr = NSString.init(format: "%02zd", date.mb_minute)
            let resultDate = NSDate.mb_date(year: date.mb_year, month: date.mb_month, day: date.mb_day, hour: hourStr, minute: minuteStr)
            return resultDate
        }
        return self
    }
    
    static func mb_date(year: NSInteger, month: NSInteger, day: NSInteger) -> NSDate? {
        NSDate.init(withYear: year, month: month, day: day)
    }

    static func mb_formatWithString(_ string: NSString, format: NSString) -> NSDate? {
        guard string.length != 0 && format.length != 0 else {
            return nil
        }
        guard let date = Date.init(fromString: (string as String), format: .custom((format as String))) else {
            return nil
        }
        return mb_convertToLocalTimeZone(date as NSDate)
    }

    static func mb_formatWithDate(_ date: NSDate, format: NSString) -> NSString? {
        guard format.length != 0 else {
            return nil
        }
        let formatter = mb_dateFormatterInCache(format: format as String)
        return formatter.string(from: date as Date) as NSString
    }

    static func mb_formatWithTimeInterval(sicence1970 timeInterval: TimeInterval, format: NSString) -> NSString? {
        let date = Date(timeIntervalSince1970: timeInterval <= 9999999999 ? timeInterval : timeInterval/1000)
        return mb_formatWithDate(date as NSDate, format: format)
    }

    static func mb_formatWithDateString(_ string: NSString, format: NSString) -> NSDate? {
        if let date = mb_parseDateTime(string, format: format) {
            return mb_convertToLocalTimeZone(date)
        }
        return nil
    }
    
    static func mb_parseDateTime(_ string: NSString, format: NSString) -> NSDate? {
        guard format.length != 0 else {
            return nil
        }
        let formatter = mb_dateFormatterInCache(format: format as String)
        return formatter.date(from: string as String) as NSDate?
    }

    func mb_yyyyMMdd() -> NSInteger {
        let dateString = NSMutableString(string: (self.description as NSString).substring(to: 10))
        dateString.replaceOccurrences(of: "-", with: "", options: .backwards, range: NSRange(location: 0, length: dateString.length))
        return NSInteger(dateString.integerValue)
    }

    private static var _dateFormatters = [String: DateFormatter]()
    static let dateFormat = "yyyy年MM月dd日 HH:mm:ss"
    static let gregorianCalendar = Calendar(identifier: .gregorian)

    func mb_numberValue() -> NSNumber? {
        NSNumber(value: mb_1970MillSecondsTimestamp())
    }
    
    func mb_1970MillSecondsTimestamp() -> UInt64 {
        UInt64(self.timeIntervalSince1970 * 1000.0)
    }

    static func mb_1970MillSecondsTimestamp() -> UInt64 {
        NSDate().mb_1970MillSecondsTimestamp()
    }

    static func mb_millSecondsNumberSince1970() -> NSNumber {
        NSNumber(value: NSDate().timeIntervalSince1970*1000)
    }

    func mb_stringWith(format: String = dateFormat) -> NSString {
        NSDate.mb_dateFormatterInCache(format: format).string(from: self as Date) as NSString
    }

    static func mb_1970MillSeconds(ms: TimeInterval, format: String = dateFormat) -> NSString {
        let date = Date.init(timeIntervalSince1970: ms / 1000.0)
        return NSDate.mb_dateFormatterInCache(format: format).string(from: date) as NSString
    }

    static func mb_dateFormatterInCache(format: String) -> DateFormatter {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if let dateFormatter = _dateFormatters[format] {
            return dateFormatter
        }
        let __dateFormatter = DateFormatter()
        __dateFormatter.dateFormat = format
        if  _dateFormatters.updateValue(__dateFormatter, forKey: format) != nil {
            return __dateFormatter
        }
        return __dateFormatter
    }
    
    func mb_chineseWeekDay(_ weekDay: NSInteger) -> NSString {
        guard weekDay>=1 && weekDay <= 7 else {
            return ""
        }
        let cnWeekDays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return cnWeekDays[weekDay-1] as NSString
    }

    @objc
    enum MBFoundationDateTimeIntervalUnit: Int {
        case seconds
        case millSeconds
    }

    func mb_timeIntervalString(_ timeInterval: TimeInterval, unit: MBFoundationDateTimeIntervalUnit = .seconds) -> NSString {
        var string = ""
        if timeInterval <= 0 {
            string = "刚刚"
        } else if timeInterval <= 60 {
            string = String(format: "%d秒", timeInterval)
        } else if timeInterval <= 60*60 {
            string = String(format: "%d分%d秒", timeInterval/60,
                            timeInterval.truncatingRemainder(dividingBy: 60))
        } else if timeInterval <= 24*60*60 {
            string = String(format: "%d小时%d分%d秒", timeInterval/(60*60),
                            timeInterval.truncatingRemainder(dividingBy: 60*60)/60,
                            timeInterval.truncatingRemainder(dividingBy: 60))
        } else {
            string = String(format: "%d天%d小时%d分%d秒", timeInterval/(24*60*60),
                            timeInterval.truncatingRemainder(dividingBy: 24*60*60)/(60*60),
                            (timeInterval.truncatingRemainder(dividingBy: 24*60*60).truncatingRemainder(dividingBy: 60*60))/60,
                            timeInterval.truncatingRemainder(dividingBy: 60))
        }

        return string as NSString
    }

    static func mb_convertToLocalTimeZone(_ GMTDate: NSDate) -> NSDate {
        GMTDate.addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
    }

    static func mb_getNowLocalTimeZone() -> NSDate {
        mb_convertToLocalTimeZone(NSDate())
    }

    func mb_stringFrom(_ format: NSString) -> NSString {
        let formatter = NSDate.mb_dateFormatterInCache(format: format as String)
        return formatter.string(from: (self as Date)) as NSString
    }
    
    func mb_convertToDayMode() -> NSDate? {
        NSDate.mb_formatWithDateString(NSString(format: "%ld", self.mb_yyyyMMdd()), format: "yyyyMMdd")
    }

    func mb_halfDayFromatString() -> NSString {
        let string = (self as Date).toString(format: .custom("yyyy年MM月dd日"))
        let halfDay = mb_isAM() ? "上午" : "下午"
        return string+halfDay as NSString
    }

    func mb_convert(with format: NSString) -> NSString {
        (self as Date).toString(format: .custom(format as String)) as NSString
    }

    // MARK: Calendar

    var mb_year: NSInteger { MBDateFormatterManager.sharedCalendar?.component(.year, from: (self as Date)) ?? -1 }
    var mb_month: NSInteger { MBDateFormatterManager.sharedCalendar?.component(.month, from: (self as Date)) ?? -1 }
    var mb_day: NSInteger { MBDateFormatterManager.sharedCalendar?.component(.day, from: (self as Date)) ?? -1 }
    var mb_weekDay: NSInteger { MBDateFormatterManager.sharedCalendar?.component(.weekday, from: (self as Date)) ?? -1 }
    var mb_hour: NSInteger { MBDateFormatterManager.sharedCalendar?.component(.hour, from: (self as Date)) ?? -1 }
    var mb_minute: NSInteger { MBDateFormatterManager.sharedCalendar?.component(.minute, from: (self as Date)) ?? -1 }
    var mb_second: NSInteger { MBDateFormatterManager.sharedCalendar?.component(.second, from: (self as Date)) ?? -1 }
    var mb_weekOfYear: NSInteger { MBDateFormatterManager.sharedCalendar?.component(.weekOfYear, from: (self as Date)) ?? -1 }
    var mb_dayOfYear: NSInteger { MBDateFormatterManager.sharedCalendar?.ordinality(of: .day, in: .year, for: (self as Date)) ?? -1 }
    var mb_dayOfMonth: NSInteger { MBDateFormatterManager.sharedCalendar?.range(of: .day, in: .month, for: (self as Date)).length ?? -1 }
    var mb_weekday_cn: NSString { mb_chineseWeekDay(self.mb_weekDay) }

    // MARK: Compare

    func mb_isSameDay(with date: NSDate?) -> Bool {
        (self as Date).compare(.isSameDay(as: date as Date?))
    }

    func mb_isToday() -> Bool {
        (self as Date).compare(.isToday)
    }
    
    func mb_isTomorrow() -> Bool {
        (self as Date).compare(.isTomorrow)
    }
    
    func mb_isYesterday() -> Bool {
        (self as Date).compare(.isYesterday)
    }

    func mb_isInPast() -> Bool {
        (self as Date).compare(.isInThePast)
    }
    
    func mb_isInFuture() -> Bool {
        (self as Date).compare(.isInTheFuture)
    }
    
    func mb_isEarilier(than date: NSDate) -> Bool {
        (self as Date).compare(.isEarlier(than: date as Date))
    }

    func mb_isLater(than date: NSDate) -> Bool {
        (self as Date).compare(.isLater(than: date as Date))
    }

    func mb_isIn(startDate: NSDate, endDate: NSDate) -> Bool {
        mb_isEarilier(than: endDate) && mb_isLater(than: startDate)
    }

    func mb_isAM() -> Bool {
        // Otherwise is "PM"
        return (self as Date).toString(format: .custom("a")) == "AM" ||
        (self as Date).toString(format: .custom("a")) == "上午"
    }

    // MARK: Adjust

    func mb_addDays(_ days: NSInteger) -> NSDate {
        (self as Date).adjust(.day, offset: Int(days)) as NSDate
    }

    func mb_addWeeks(_ weeks: NSInteger) -> NSDate {
        (self as Date).adjust(.week, offset: Int(weeks)) as NSDate
    }

    func mb_addMonths(_ months: NSInteger) -> NSDate {
        (self as Date).adjust(.month, offset: Int(months)) as NSDate
    }

    func mb_addYears(_ years: NSInteger) -> NSDate {
        (self as Date).adjust(.year, offset: Int(years)) as NSDate
    }
    
    func mb_subtractDays(_ days: NSInteger) -> NSDate {
        (self as Date).adjust(.day, offset: Int(-days)) as NSDate
    }

    func mb_subtractWeeks(_ weeks: NSInteger) -> NSDate {
        (self as Date).adjust(.week, offset: Int(-weeks)) as NSDate
    }

    func mb_subtractMonths(_ months: NSInteger) -> NSDate {
        (self as Date).adjust(.month, offset: Int(-months)) as NSDate
    }

    func mb_subtractYears(_ years: NSInteger) -> NSDate {
        (self as Date).adjust(.year, offset: Int(-years)) as NSDate
    }

    // MARK: Date for

    func mb_zeroTime() -> NSDate {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: (self as Date))
        return Calendar.current.date(from: components)! as NSDate
    }

    // MARK: Time since
    
    func mb_getDayIntervalSinceDate(_ date: NSDate) -> NSInteger {
        let calendar = Calendar.current
        let end = calendar.ordinality(of: .day, in: .era, for: self as Date)
        let start = calendar.ordinality(of: .day, in: .era, for: date as Date)
        return abs(end! - start!)
    }
    
    static func mb_getDayDiff(startDate: NSDate, endDate: NSDate) -> NSInteger {
        endDate.mb_getDaysSinceDate(startDate)
    }

    func mb_getDaysSinceDate(_ date: NSDate) -> NSInteger {
        NSInteger((self as Date).since(date as Date, in: .day))
    }

    func mb_getWeeksSinceDate(_ date: NSDate) -> NSInteger {
        NSInteger((self as Date).since(date as Date, in: .week))
    }

    func mb_getMonthsSinceDate(_ date: NSDate) -> NSInteger {
        NSInteger((self as Date).since(date as Date, in: .month))
    }

    func mb_getYearsSinceDate(_ date: NSDate) -> NSInteger {
        NSInteger((self as Date).since(date as Date, in: .year))
    }

    func mb_relativeTimeString() -> NSString {
        (self as Date).toStringWithRelativeTime() as NSString
    }

    @objc
    enum MBFoundationHistoryDateFromatType: Int {

        /**
         规则A出自 - (NSString *)timeStringFromDate;
         
         60秒以内：HH:mm
         30分钟以内： xx分钟以前
         当天，非以上：HH:mm
         昨天：昨天 HH:mm
         今年前天以前：MM-dd HH:mm
         非今年：YYYY-MM-dd HH:mm
         */
        case A

        /**
         规则B出自 - (NSString *)historyString;
         
         60秒以内：刚刚
         60分钟以内：xx分钟以前
         24小时以内：xx小时前
         24*7小时以内：xx天前
         以上均不符合：yyyy-MM-dd
         */
        case B

        /**
         规则C出自 - (NSString *)dateHistoryString;
         
         60秒以内：刚刚
         30分钟以内：xx分钟前
         24小时以内：昨天 HH:mm 或 HH:mm
         以上均不符合：HH:mm
         */
        case C
    }

    func mb_historyStringWith(type: MBFoundationHistoryDateFromatType = .A) -> NSString? {
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970

        let sec: Double = abs(now - time)
        let min: Double = round(sec/60)
        let hr: Double = round(min/60)
        let d: Double = round(hr/24)

        switch type {
            case .A:
                let stringsA: [RelativeTimeStringType: String] = [.nowPast: mb_convert(with: "HH:mm") as String,
                                                                  .nowFuture: "",
                                                                  .secondsPast: mb_convert(with: "HH:mm") as String,
                                                                  .secondsFuture: "",
                                                                  .oneMinutePast: "1分钟前",
                                                                  .oneMinuteFuture: "",
                                                                  .minutesPast: min<=30 ? String(format: "%d分钟前", min) : mb_convert(with: "HH:mm") as String,
                                                                  .minutesFuture: "",
                                                                  .oneHourPast: mb_convert(with: "HH:mm") as String,
                                                                  .oneHourFuture: "",
                                                                  .hoursPast: mb_convert(with: "HH:mm") as String,
                                                                  .hoursFuture: "",
                                                                  .oneDayPast: mb_convert(with: "昨天 HH:mm") as String,
                                                                  .oneDayFuture: "",
                                                                  .daysPast: mb_convert(with: "MM-dd HH:mm") as String,
                                                                  .daysFuture: "",
                                                                  .oneWeekPast: mb_convert(with: "MM-dd HH:mm") as String,
                                                                  .oneWeekFuture: "",
                                                                  .weeksPast: mb_convert(with: "MM-dd HH:mm") as String,
                                                                  .weeksFuture: "",
                                                                  .oneMonthPast: mb_convert(with: "MM-dd HH:mm") as String,
                                                                  .oneMonthFuture: "",
                                                                  .monthsPast: mb_convert(with: "MM-dd HH:mm") as String,
                                                                  .monthsFuture: "",
                                                                  .oneYearPast: mb_convert(with: "yyyy-MM-dd HH:mm") as String,
                                                                  .oneYearFuture: "",
                                                                  .yearsPast: mb_convert(with: "yyyy-MM-dd HH:mm") as String,
                                                                  .yearsFuture: ""
                ]
                return (self as Date).toStringWithRelativeTime(strings: stringsA) as NSString
            case .B:
                let stringsB: [RelativeTimeStringType: String] = [.nowPast: "刚刚",
                                                                  .nowFuture: "",
                                                                  .secondsPast: "刚刚",
                                                                  .secondsFuture: "",
                                                                  .oneMinutePast: "1分钟前",
                                                                  .oneMinuteFuture: "",
                                                                  .minutesPast: String(format: "%.f分钟前", min),
                                                                  .minutesFuture: "",
                                                                  .oneHourPast: "1小时前",
                                                                  .oneHourFuture: "",
                                                                  .hoursPast: String(format: "%.f小时前", hr),
                                                                  .hoursFuture: "",
                                                                  .oneDayPast: "1天前",
                                                                  .oneDayFuture: "tomorrow",
                                                                  .daysPast: String(format: "%.f天前", d),
                                                                  .daysFuture: "",
                                                                  .oneWeekPast: mb_convert(with: "yyyy-MM-dd") as String,
                                                                  .oneWeekFuture: "",
                                                                  .weeksPast: mb_convert(with: "yyyy-MM-dd") as String,
                                                                  .weeksFuture: "",
                                                                  .oneMonthPast: mb_convert(with: "yyyy-MM-dd") as String,
                                                                  .oneMonthFuture: "",
                                                                  .monthsPast: mb_convert(with: "yyyy-MM-dd") as String,
                                                                  .monthsFuture: "",
                                                                  .oneYearPast: mb_convert(with: "yyyy-MM-dd") as String,
                                                                  .oneYearFuture: "",
                                                                  .yearsPast: mb_convert(with: "yyyy-MM-dd") as String,
                                                                  .yearsFuture: ""
                ]
                return (self as Date).toStringWithRelativeTime(strings: stringsB) as NSString
            case .C:
                let stringsC: [RelativeTimeStringType: String] = [.nowPast: "刚刚",
                                                                  .nowFuture: "",
                                                                  .secondsPast: "刚刚",
                                                                  .secondsFuture: "",
                                                                  .oneMinutePast: "1分钟前",
                                                                  .oneMinuteFuture: "",
                                                                  .minutesPast: min<=30 ? String(format: "%.f分钟前", min) : mb_convert(with: "HH:mm") as String,
                                                                  .minutesFuture: "",
                                                                  .oneHourPast: mb_convert(with: "HH:mm") as String,
                                                                  .oneHourFuture: "",
                                                                  .hoursPast: mb_convert(with: "HH:mm") as String,
                                                                  .hoursFuture: "",
                                                                  .oneDayPast: mb_convert(with: "昨天 HH:mm") as String,
                                                                  .oneDayFuture: "",
                                                                  .daysPast: mb_convert(with: "HH:mm") as String,
                                                                  .daysFuture: "",
                                                                  .oneWeekPast: mb_convert(with: "HH:mm") as String,
                                                                  .oneWeekFuture: "",
                                                                  .weeksPast: mb_convert(with: "HH:mm") as String,
                                                                  .weeksFuture: "",
                                                                  .oneMonthPast: mb_convert(with: "HH:mm") as String,
                                                                  .oneMonthFuture: "",
                                                                  .monthsPast: mb_convert(with: "HH:mm") as String,
                                                                  .monthsFuture: "",
                                                                  .oneYearPast: mb_convert(with: "HH:mm") as String,
                                                                  .oneYearFuture: "",
                                                                  .yearsPast: mb_convert(with: "HH:mm") as String,
                                                                  .yearsFuture: ""
                ]
                return (self as Date).toStringWithRelativeTime(strings: stringsC) as NSString
            default: break
        }

        return nil
    }

}

private func negative(_ number: NSInteger) -> NSInteger {
    number > 0 ? -number : number
}
