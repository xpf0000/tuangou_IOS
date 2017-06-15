//
//  NoticesListVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class NoticesListVC: UIViewController {

    let table = XTableView()
    var oid = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "消息中心"
        
        table.backgroundColor = "f2f2f2".color()
        table.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH-64)

        self.view.addSubview(table)
        
        table.cellHeight = 75+16
        
        var url = Api.BaseUrl+"?ctl=notice&act=index&r_type=1&isapp=true"
        url += "&page=[page]"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","list"], model: NewsModel.self, CellIdentifier: "NoticeCell")
        
        table.show()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
