//
//  DataCache.swift
//  swiftTest
//
//  Created by X on 15/3/3.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit

class DataCache: NSObject {

    static let Share = DataCache()
    
    var User = UserModel()
    var city = ItemsBean()
    lazy var ShopSearchKey:SearchKeyModel = SearchKeyModel()
    
    fileprivate override init() {
        super.init()
        
        if let model = UserModel.read(name: "User")
        {
            User = model as! UserModel
        }
        else
        {
            CloudPushSDK.removeAlias(nil) { (res) in
            
                print(res.debugDescription)
                print("清空阿里推送!!!!!!!")
                
            }
        }
        
        if let model = ItemsBean.read(name: "City")
        {
            city = model as! ItemsBean
            
            Api.city_city_change(city_id: city.id, block: { (true) in
                
            })
            
        }
        
        if let model = SearchKeyModel.read(name: "ShopSearchKeyModel")
        {
            ShopSearchKey = model as! SearchKeyModel
        }
        else
        {
            ShopSearchKey.name = "ShopSearchKeyModel"
        }
        
                
}
    
    
  
    
}
