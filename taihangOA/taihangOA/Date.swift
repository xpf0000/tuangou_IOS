//
//  Date.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

extension Date {
    
    static func now()->Date
    {
        let date:Date=Date()
        let zone:TimeZone=TimeZone.current
        let interval:TimeInterval=TimeInterval(zone.secondsFromGMT(for: date))
        return date.addingTimeInterval(interval)
    }
    
    func formart()->Date
    {
        let zone:TimeZone=TimeZone.current
        let interval:TimeInterval=TimeInterval(zone.secondsFromGMT(for: self))
        return self.addingTimeInterval(interval)
    }
    
    func dateComponent() -> DateComponents
    {
        let calendar=Calendar.current
        let unitFlags: NSCalendar.Unit=[NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.weekday, NSCalendar.Unit.day]
        
        return (calendar as NSCalendar).components(unitFlags, from: self)
    }
    
    func toStr(_ format:String)->String?
    {
        let dateFormatter:DateFormatter=DateFormatter()
        dateFormatter.dateFormat=format
        return dateFormatter.string(from: self)
    }

}
