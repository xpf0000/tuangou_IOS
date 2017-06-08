//
//  UserCollectModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class UserCollectModel: Reflect {

    var  page:PageModel = PageModel()
    var  page_title = ""
    var  goods_list:[GoodsListBean] = []
    
    class GoodsListBean : Reflect{
    
        var  id = ""
        var  cid = ""
        var  icon = ""
        var  sub_name = ""
        var origin_price = 0.00
        var current_price = 0.00
        var  buy_count = ""
        var  brief = ""
        
        var  end_time = ""
        
    }
    
}
