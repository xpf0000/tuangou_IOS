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
    
    lazy var StoresSearchKey:SearchKeyModel = SearchKeyModel()
    
    fileprivate override init() {
        super.init()
        
        if let model = UserModel.read(name: "User")
        {
            User = model as! UserModel
            
            Api.user_getUinfo(uid: User.id, uname: User.user_name) { [weak self](m) in
                
                let sess_id = self?.User.sess_id ?? ""
                
                self?.User = m
                self?.User.sess_id = sess_id
                self?.User.save()
                
               "UserAccountChange".postNotice()
                
            }
            
        }
        else
        {
//            CloudPushSDK.removeAlias(nil) { (res) in
//            
//                print(res.debugDescription)
//                print("清空阿里推送!!!!!!!")
//                
//            }
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
        
        if let model = SearchKeyModel.read(name: "StoresSearchKey")
        {
            StoresSearchKey = model as! SearchKeyModel
        }
        else
        {
            StoresSearchKey.name = "StoresSearchKey"
        }
        
                
}
    

    
}
