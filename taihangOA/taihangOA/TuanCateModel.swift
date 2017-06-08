//
//  TuanCateModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class TuanCateModel: Reflect {

    var id = 0
    var  name = ""
    var  icon_img = ""
    var  iconfont = ""
    var  iconcolor = ""
    var bcate_type:[BcateTypeBean] = []
    
    class BcateTypeBean:Reflect {

        var id = 0
        var cate_id = 0
        var  name = ""
    
    }
    
}
