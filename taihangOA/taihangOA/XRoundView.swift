//
//  XRoundView.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class XRoundView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        print("rect : \(rect)")
        
        if self.XCornerRadius != nil
        {
            print("rect111 : \(rect)")
            drawCornerRadius(rect)
        }
        
    }

}
