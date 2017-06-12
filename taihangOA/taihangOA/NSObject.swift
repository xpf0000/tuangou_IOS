//
//  NSObject.swift
//  lejia
//
//  Created by X on 15/11/4.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import Foundation
import UIKit

enum RegularType : String{
    
    case NickName="[~!/@#$%^&#$%^&amp;*()-_=+\\|[{}];:\'\",&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&#$%^&amp;*()-_=+\\|[{}];:\'\",&lt;.&gt;/?]+"
    
    case Phone="^(1)[0-9]{10}$"
    case Email="^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
}


extension NSObject{
    
    func checkNull()->Bool
    {
        var r = false
        
        if let text = self.value(forKey: "text") as? String
        {
            if(text.trim() != "")
            {
                r = true
            }
        }
        
        if !r
        {
            if self is UIView
            {
                (self as! UIView).shake()
            }
        }
        
        return r
    }
    
    
    func checkNickName()->Bool
    {
        var r = false
        if let text = self.value(forKey: "text") as? String
        {
            if(!text.match(.NickName))
            {
                r = true
            }
        }
        
        if !r
        {
            if self is UIView
            {
                (self as! UIView).endEdit()
                XMessage.show("不能有特殊字符")
            }
        }
        
        return r
        
    }
    
    
    func checkPhone()->Bool
    {
        var r = false
        if let text = self.value(forKey: "text") as? String
        {
            if(text.match(.Phone))
            {
                r = true
            }
        }
        
        if !r
        {
            if self is UIView
            {
                (self as! UIView).endEdit()
                XMessage.show("手机号码格式有误")
            }
        }
        
        return r
        
    }
    
    func checkEmail()->Bool
    {
        var r = false
        if let text = self.value(forKey: "text") as? String
        {
            if(text.match(.Email))
            {
                r = true
            }
        }
        
        if !r
        {
            if self is UIView
            {
                (self as! UIView).endEdit()
                XMessage.show("邮箱格式有误")
            }
        }
        
        return r
        
    }
    
    func checkLength(_ min:Int,max:Int)->Bool
    {
        var r = false
        if let text = self.value(forKey: "text") as? String
        {
            if(text.trim().length() >= min && text.trim().length() <= max)
            {
                r = true
            }
        }
        
        return r
    }
    
    func checkLength(_ str:String,min:Int,max:Int)->Bool
    {
        let r = self.checkLength(min, max: max)
    
        if !r
        {
            if self is UIView
            {
                (self as! UIView).endEdit()
                XMessage.show(str+"长度为\(min)至\(max)位")
            }
        }
        
        return r
    }
    
    
    
}
