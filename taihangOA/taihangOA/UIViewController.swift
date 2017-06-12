//
//  UIViewController.swift
//  OA
//
//  Created by X on 15/5/18.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

private var backButtonKey : CChar?

extension UIViewController{
    
    
    weak var backButton:UIButton?
        {
        get
        {
            return objc_getAssociatedObject(self, &backButtonKey) as? UIButton
        }
        set(newValue) {
            self.willChangeValue(forKey: "backButtonKey")
            objc_setAssociatedObject(self, &backButtonKey, newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            self.didChangeValue(forKey: "backButtonKey")
            
        }
    }

    
    
    func checkIsLogin()->Bool
    {
        if(DataCache.Share.User.id == "")
        {
            
            let vc:LoginVC = "LoginVC".VC(name: "Main") as! LoginVC
            let nv:XNavigationController = XNavigationController(rootViewController: vc)
            self.show(nv, sender: nil)
            
            return false
        }
        else
        {
            if(DataCache.Share.User.is_effect != 1)
            {
                let vc = "RenzhengVC".VC(name: "Main")
                let nv:XNavigationController = XNavigationController(rootViewController: vc)
                self.show(nv, sender: nil)
                
                return false
            }
        }
        
        return true
    }
    
        
    func pop()
    {
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
        
        if let nv = self.navigationController{
            
            if(nv.viewControllers.count > 1)
            {
                return
            }
            
        }
        
        self.dismiss(animated: true) { () -> Void in
            
        }
        
    }
    
    
    func addBackButton()
    {
        let button=UIButton(type: UIButtonType.custom)
        button.frame=CGRect(x: 0, y: 0, width: 22, height: 22);
        button.setBackgroundImage("back@2x.png".image(), for: UIControlState())
        button.showsTouchWhenHighlighted = true
        button.isExclusiveTouch = true
        button.addTarget(self, action: #selector(pop), for: UIControlEvents.touchUpInside)
        let leftItem=UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem=leftItem;
        
        self.backButton=button
    }
    
    
    func addSearchButton(_ block:@escaping XButtonBlock)->UIButton
    {
        let button=UIButton(type: UIButtonType.custom)
        button.click(block)
        button.frame=CGRect(x: 0, y: 0, width: 21, height: 21);
        button.setBackgroundImage("search@3x.png".image(), for: UIControlState())
        button.showsTouchWhenHighlighted = true
        button.isExclusiveTouch = true
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        return button
    }
        

}
