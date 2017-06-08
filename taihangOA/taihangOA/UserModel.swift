//
//  UserModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class UserModel: Reflect {

    var id = ""
    var user_name = ""
    var mobile = ""
    var is_effect = 0
    var is_tmp = ""
    var money = ""
    var avatar = ""
    var real_name = ""
    var rezhenging = false
    var id_number = ""
    
    func reset()
    {
        id = ""
        user_name = ""
        mobile = ""
        is_effect = 0
        is_tmp = ""
        money = ""
        avatar = ""
        real_name = ""
        rezhenging = false
        id_number = ""
        save()
    }
    
    func save()
    {
        _ = UserModel.save(obj: self, name: "User")
    }
    
    
}
