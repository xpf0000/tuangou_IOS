//
//  OrderVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class OrderVC: UIViewController {

    
    @IBOutlet weak var menu: XHorizontalMenuView!
    
    @IBOutlet weak var main: XHorizontalMainView!
    
    lazy var classArr:[XHorizontalMenuModel] = []
    
    let dic = ["0":"全部","1":"待付款","2":"待使用","3":"待评价","4":"退款"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单"
        main.menu = menu
        menu.menuSelectColor = APPBlueColor
        menu.line.backgroundColor = APPBlueColor
        menu.menuTextColor = "333333".color()
        menu.menuBGColor = UIColor.white
        menu.menuPageNum = 5
        menu.menuMaxScale = 1.0
        menu.menuFontSize = 16.0
        
        getCategory()
        
    }
    
    
    func getCategory()
    {
        self.classArr.removeAll(keepingCapacity: false)
        
        for (id,name) in dic
        {
            
            let m = XHorizontalMenuModel()
            m.title = name
            
            let table = XTableView()
            table.contentInset.bottom = 50.0
            table.cellHeight = 75+16
            
            var url = Api.BaseUrl+"?ctl=uc_order&act=app_index&r_type=1&isapp=true"
            url += "&uid="+DataCache.Share.User.id
            url += "&status="+id
            url += "&page=[page]"
            
            table.setHandle(url, pageStr: "[page]", keys: ["data","item"], model: OrderItemModel.self, CellIdentifier: "OrderCell")
            
            table.show()
            
            m.view = table
            
            self.classArr.append(m)
        }
        
        self.menu.menuArr = self.classArr
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
}
