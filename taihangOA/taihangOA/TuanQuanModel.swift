//
//  TuanQuanModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class TuanQuanModel: Reflect {

    var  id = 0
    var name = ""
    var  quan_sub:[QuanSubBean] = []
    
    var checked = false
    
    class QuanSubBean : Reflect{
        
        var  id = 0 = 0
        var  pid = 0
        var name = ""
        
        var checked = false
    }
    
}
