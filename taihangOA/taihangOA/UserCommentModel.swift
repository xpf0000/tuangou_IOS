//
//  UserCommentModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class UserCommentModel: Reflect {
    
    var  page:PageModel = PageModel()
    var item:[ItemBean] = []

    class ItemBean:Reflect {
      
        var type = ""
        var data_id = ""
        var content = ""
        var create_time = ""
        var reply_time = ""
        var reply_content = ""
        var name = ""
        var point = ""
        var oimages:[String] = []
        var icon = ""
        var sub_name = ""
        
    }
    
}
