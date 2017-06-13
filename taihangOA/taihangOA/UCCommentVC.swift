//
//  UCCommentVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class UCCommentVC: UIViewController {
    
    @IBOutlet weak var table: XTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        var url = Api.BaseUrl+"?ctl=uc_review&act=app_index&r_type=1&isapp=true"
        url += "&page=[page]"
        url += "&uid="+DataCache.Share.User.id
        
        table.setHandle(url, pageStr: "[page]", keys: ["data","item"], model: ItemBean.self, CellIdentifier: "CommentCell")
    
        table.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
}
