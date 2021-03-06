//
//  Date+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/6.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//


enum My_TimeEnum {
    case week(Int)
    case day(Int)
    case hour(Int)
    case minute(Int)
    case secend_Int(Int)
    case secend_Intervsl(TimeInterval)

    func getTimeInterval() -> TimeInterval{
        switch self {
        case .week(let num):
            return TimeInterval(num * 7 * 24 * 60 * 60)
        case .day(let num):
            return TimeInterval(num * 24 * 60 * 60)
        case .hour(let num):
            return TimeInterval(num * 60 * 60)
        case .minute(let num):
            return TimeInterval(num * 60)
        case .secend_Int(let num):
            return TimeInterval(num)
        case .secend_Intervsl(let num):
            return num
        }
    }
}

extension Optional where Wrapped == Date{
    public var isToday: Bool{
        if self == nil {
            return false
        }else{
            return self!.isToday
        }
    }
}

extension Date {
    func toString(_ dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String {
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
    
    func toTimeInterval() -> TimeInterval {
        return self.timeIntervalSince1970
    }

    var yearString:String{
        return toString("yyyy")
    }
    
    var monthString:String{
        return toString("MM")
    }
    
    var dayString:String{
        return toString("dd")
    }
    
    var hourString:String{
        return toString("HH")
    }
    
    var minuteString:String{
        return toString("mm")
    }
    
    var secendString:String{
        return toString("ss")
    }
    
    var weekend:Int{
        let interval = Int(self.timeIntervalSince1970) + NSTimeZone.local.secondsFromGMT()
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
        
//        guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else { return 1 }
//        let components = calendar.components([.weekday], from: self)
//        let weekday = components.weekday!
//        return weekday
    }
    
    // 是否是今天
    public var isToday: Bool{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: self) == format.string(from: Date())
    }

    static func date(from string:String, formate:String) -> Date?{
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = formate
        let date = formatter.date(from: string)
        return date
    }
    
    func addTime(_ time:My_TimeEnum) -> Date {
        let t = self.timeIntervalSince1970 + time.getTimeInterval()
        return Date.init(timeIntervalSince1970: t)
    }
    
    ///返回星期几
    func getweekDayString() ->String{
        let comps = self.weekend
        var str = ""
        if comps == 1 {
            str = "周一"
        }else if comps == 2 {
            str = "周二"
        }else if comps == 3 {
            str =  "周三"
        }else if comps == 4 {
            str =  "周四"
        }else if comps == 5 {
            str =  "周五"
        }else if comps == 6 {
            str =  "周六"
        }else if comps == 7 {
            str =  "周日"
        }
        return str
    }
    
    ///返回第几周
    func getWeek() -> Int{
        guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
            return 1
        }
        let components = calendar.components([.weekOfYear,.weekOfMonth,.weekday,.weekdayOrdinal], from: self)
        //今年的第几周
        var weekOfYear = components.weekOfYear!
        
        //这个月第几周
        let weekOfMonth = components.weekOfMonth!
        //周几
        let weekday = components.weekday!
        //这个月第几周
        let weekdayOrdinal = components.weekdayOrdinal!
        if weekOfYear == 1 && weekOfMonth != 1 {
            weekOfYear = 53
        }
        return weekOfYear
    }
    
    func daysBetweenDate(_ toDate:Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    
}
