//
//  NewsVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class NewsVC: UIViewController {

    @IBOutlet weak var menu: XHorizontalMenuView!
    
    @IBOutlet weak var main: XHorizontalMainView!
    
    lazy var classArr:[XHorizontalMenuModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯"
        main.menu = menu
        menu.menuSelectColor = APPBlueColor
        menu.line.backgroundColor = APPBlueColor
        menu.menuTextColor = "333333".color()
        menu.menuBGColor = UIColor.white
        menu.menuPageNum = 4
        menu.menuMaxScale = 1.0
        menu.menuFontSize = 16.0
        
        getCategory()
        
    }
    
    
    func getCategory()
    {
        self.classArr.removeAll(keepingCapacity: false)
        
        Api.news_all_cate { [weak self](arrs) in
            
            for item in arrs
            {
              
                let m = XHorizontalMenuModel()
                m.title = item.title
                
                let table = XTableView()
                table.contentInset.bottom = 50.0
                table.cellHeight = 75+16
                
                var url = Api.BaseUrl+"?ctl=news&act=getList&r_type=1&isapp=true"
                url += "&tid="+item.id
                url += "&page=[page]"
            
                table.setHandle(url, pageStr: "[page]", keys: ["data"], model: NewsModel.self, CellIdentifier: "NewsCell")
                
                table.show()
                
                m.view = table
                
                self?.classArr.append(m)
            }
            
            self?.menu.menuArr = self!.classArr
            
        }
        
        
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TabIndex = 2
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
