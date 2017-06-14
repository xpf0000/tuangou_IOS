//
//  CouponListVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/14.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CouponListVC: UIViewController {

    let table = XTableView()
    var oid = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "百家券"
        
        table.backgroundColor = "f2f2f2".color()
        table.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH-50)
        table.separatorStyle = .none
        self.view.addSubview(table)
        
        table.contentInset.bottom = 20
        
        table.cellHeight = 320
        
        var url = Api.BaseUrl+"?ctl=uc_coupon&act=info&r_type=1&isapp=true"
        url += "&oid="+oid
        url += "&uid="+DataCache.Share.User.id
        table.postDict = ["name":name as AnyObject]
        table.setHandle(url, pageStr: "[page]", keys: ["data"], model: CouponModel.self, CellIdentifier: "CouponCell")
        
        table.show()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
