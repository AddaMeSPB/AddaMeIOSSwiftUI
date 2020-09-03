//
//  DateHelper.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 03.09.2020.
//

import Foundation

public class DateHelper {
    private static let formatter = DateFormatter()
    private static let timeZone = TimeZone.current
    private static let timeLocale = Locale.current

    public static func fromISO8601String(_ dateString: String) -> Date? {
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: dateString)
    }

    public static func toISO8601String(_ date: Date) -> String {
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: date)
    }
    
    static func dateFromString(_ dateAsString: String?) -> Date? {
        guard let string = dateAsString else { return nil }
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        let val = formatter.date(from: string)
        return val
    }
    
    static func dateToString(_ dateIn: Date?) -> String? {
        guard let date = dateIn else { return nil }
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        let val = formatter.string(from: date)
        return val
    }
    
    static func getDateFromTimeStamp(timeStamp : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"
        
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    static func dateFormatter(timestamp: Double?) -> String? {
        if let timestamp = timestamp {
            let date = Date(timeIntervalSinceReferenceDate: timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.autoupdatingCurrent
            let timeSinceDateInSconds = Date().timeIntervalSince(date)
            let secondInDays: TimeInterval = 24*60*60
            
            if timeSinceDateInSconds > 7 * secondInDays {
                dateFormatter.dateFormat = "MM/dd/yy"
            } else if timeSinceDateInSconds > secondInDays {
                dateFormatter.dateFormat = "EEEE"
            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
}

let mediaDurationFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = [.pad]
    formatter.unitsStyle = .positional
    return formatter
}()

let millisecondsPerSecond: Double = 1000
//let nanosecondsPerSecond: CMTimeScale = 1000000000
