//
//  ViewController.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Cartography
import SwiftyJSON
import Kingfisher

class HomeVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let topBar = HomeTopBar()
        topBar.frame = CGRect(x: 0, y: 0, width: SW, height: 44.0)
        
        self.navigationController?.navigationBar.addSubview(topBar)
        
        initTabBar()
        
        
    }
    
    func initTabBar()
    {
        let arr:Array<UITabBarItem> = (self.tabBarController?.tabBar.items)!
        let scale = Int(UIScreen.main.scale)

        for (i,item) in arr.enumerated()
        {
            item.image="tab_\(i)@\(scale)x.png".image()!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.selectedImage="tab_\(i)_1@\(scale)x.png".image()!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
            item.setTitleTextAttributes([NSForegroundColorAttributeName:APPBlueColor,NSFontAttributeName:UIFont.systemFont(ofSize: 13.0)], for: UIControlState.selected)
            
            item.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13.0)], for: UIControlState.normal)
            
        }
    }
    
    
    
    func dodeinit()
    {
        
   
    }
    
    deinit
    {
        dodeinit()
        print("HomeVC deinit !!!!!!!!!!!!!!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //banner.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

