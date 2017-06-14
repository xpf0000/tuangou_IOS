//
//  Double.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/14.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

extension Double {
    
    func roundDouble() -> Double
    {
        return (floor(self*100 + 0.5))/100;
    }
    
    func roundDouble(num:Int) -> Double
    {
        let p = pow(Double(10), Double(num))
        
        return (floor(self*p + 0.5))/p;
    }
    
}
