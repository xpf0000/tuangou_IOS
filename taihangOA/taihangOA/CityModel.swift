//
//  CityModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CityModel: Reflect {

    var  city_list:[CityListBean] = []
    var  hot_city:[HotCityBean] = []
    
}

class CityListBean:Reflect {
    var  Letter = ""
    var  items:[ItemsBean] = []
    
}

class ItemsBean : Reflect {
    var  id = ""
    var   name = ""
    var   uname = ""
    var   is_open = ""
    var   zm = ""
    var   url = ""
    
    func save()
    {
        _  = ItemsBean.save(obj: self, name: "City")
    }
    
}


class HotCityBean:Reflect {
    var   id = ""
    var   name = ""
}




