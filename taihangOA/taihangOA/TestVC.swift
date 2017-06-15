//
//  TestVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    @IBOutlet weak var roundView: XRoundView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cm1 = XCornerRadiusModel()
        cm1.FillPath = true
        cm1.FillColor = APPBlueColor
        
        cm1.StrokePath = true
        cm1.StrokeColor = "FF7F00".color()
        
        cm1.BorderSidesType = [.All]
        cm1.BorderLineWidth = 5.0
        
        
        print(cm1.BorderSidesType.contains(.All))
        print(cm1.BorderSidesType.contains(.Bottom))
        print(cm1.BorderSidesType.contains(.Left))
        print(cm1.BorderSidesType.contains(.None))
        print(cm1.BorderSidesType.contains(.Right))
        print(cm1.BorderSidesType.contains(.Top))
        
        
        cm1.CornerRadius=20.0
        
        cm1.CornerRadiusType = [.topRight,.topLeft]
        
        roundView.XCornerRadius = cm1
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

}
