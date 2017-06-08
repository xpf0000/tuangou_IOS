//
//  XNavigationController.swift
//  swiftTest
//
//  Created by X on 15/3/17.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit

class XNavigationController: UINavigationController
{
    var backGroundView:UIView?
    let alphaView:UIView = UIView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.inita()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.inita()
    }
    
    
    func inita()
    {

        
        
        //取出设置主题的对象
        let navBar = UINavigationBar.appearance()
        navBar.tintColor=UIColor.white
        
        navBar.setBackgroundImage(APPBlueColor.image(), for:.default)
        navBar.titleTextAttributes=[NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 20.0)]
    
        self.navigationBar.isTranslucent = false
        self.navigationBar.shadowImage = UIColor.clear.image()
        
                
//        self.navigationBar.translucent = true
//        alphaView.frame=CGRectMake(0, 0, swidth, (self.navigationBar.frame.size.height)+20)
//        alphaView.backgroundColor = blueBGC
//        self.view.insertSubview(alphaView, belowSubview: self.navigationBar)
   
        
    }
    
    func setAlpha(_ a:CGFloat)
    {
        var img:UIImage?
        if(a==1)
        {
            img=UIColor(red: 33.0/255.0, green: 173.0/255.0, blue: 253.0/255.0, alpha: 1.0).image()
            self.navigationBar.shadowImage = nil
            self.navigationBar.isTranslucent = false;
        }
        else
        {
            img=UIColor(red: 33.0/255.0, green: 173.0/255.0, blue: 253.0/255.0, alpha: 0.0).image()
            self.navigationBar.shadowImage = UIColor.clear.image()
            self.navigationBar.isTranslucent = true;
        }
        
        self.navigationBar.setBackgroundImage(img, for:.default)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    deinit
    {
        backGroundView?.removeFromSuperview()
        backGroundView=nil
    }
    
   
}
