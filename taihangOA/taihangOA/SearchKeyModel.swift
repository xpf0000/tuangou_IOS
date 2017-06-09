//
//  SearchKeyModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class SearchKeyModel: Reflect {

    var name = ""
    var keyArr:[String] = []
    
    func add(str:String)
    {
        if keyArr.contains(str)
        {
            keyArr.remove(at: keyArr.index(of: str)!)
        }
        
        keyArr.insert(str, at: 0)
        
        save()
    }
    
    func del(str:String)
    {
        if keyArr.contains(str)
        {
            keyArr.remove(at: keyArr.index(of: str)!)
        }
        
        save()
    }
    
    func clean()
    {
        keyArr.removeAll(keepingCapacity: false)
        
        save()
    }
    
    func save()
    {
        SearchKeyModel.delete(name: name)
        _ = SearchKeyModel.save(obj: self, name: name)
    }

    
}
