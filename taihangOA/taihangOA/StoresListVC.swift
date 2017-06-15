//
//  StoresListVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import SwiftyJSON


class StoresListVC: UIViewController,ReactionMenuDelegate {
    
    @IBOutlet weak var topMenu: ReactionMenuView!
    
    @IBOutlet weak var tableview: XTableView!
    
    var nowCate : BcateTypeBean = BcateTypeBean()
    var nowQuan : QuanSubBean = QuanSubBean()
    var nowOrder : TuanNavModel = TuanNavModel()
    
    var cate_id = ""
    
    var topCellArr:Array<Array<ReactionMenuItemModel>> = [[],[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商家"
        self.addBackButton()
        
        //设置菜单的父视图
        topMenu.superView = self.view
        //菜单的选项
        topMenu.titles = ["全部区域","全部分类","距离排序"]
        
        //菜单的个数  决定动态宽度
        topMenu.tableWidths = [[0.45,0.55],[0.45,0.55],[1.0]]
        topMenu.delegate = self
        topMenu.onlyOne = false
        
        getTopData()
        
        tableview.contentInset.bottom = 50.0
        
        var url = Api.BaseUrl+"?ctl=stores&act=app_index&r_type=1&isapp=true"
        
        url += "&page=[page]"
        url += "&city_id="+DataCache.Share.city.id
        url += "&cate_id=\(nowCate.cate_id)"
        url += "&tid=\(nowCate.id)"
        url += "&qid=\(nowQuan.id)"
        url += "&order_type="+nowOrder.code
        url += "&xpoint=\(XPosition.Share.postion.longitude)"
        url += "&ypoint=\(XPosition.Share.postion.latitude)"
        
        tableview.setHandle(url, pageStr: "[page]", keys: ["data","item"], model: StoresModel.self, CellIdentifier: "StoresCell")
        tableview.cellHeight = 100.0
        tableview.show()
        
        _ = addSearchButton { [weak self](btn) in
            
            let vc:StoresSearchVC = StoresSearchVC()
            let nv=XNavigationController(rootViewController: vc)
            
            self?.present(nv, animated: true) { () -> Void in
                
            }
            
        }
        
    }
    
    func getTopData()
    {
        Api.tuan_quan_list { [weak self](arrs) in
            
            self?.putTown(o: arrs)
            
        }
        
        Api.tuan_cate_list { [weak self](arrs) in
            
            self?.putCate(o: arrs)
            
        }
        
        Api.tuan_nav_list { [weak self](arrs) in
            
            self?.putOrder(o: arrs)
            
        }
        
        
        
    }
    
    
    func putTown(o:Any)
    {
        var arr:[ReactionMenuItemModel] = []
        var k = 0
        for model in o as! [TuanQuanModel]
        {
            let rm = ReactionMenuItemModel()
            rm.id = model.id
            rm.sid = "\(model.id)"
            rm.title = model.name
            
            rm.pid = k
            
            arr.append(rm)
            
            for i in model.quan_sub
            {
                let rm = ReactionMenuItemModel()
                rm.id = i.id
                rm.title = i.name
                rm.level = 1
                rm.fid = k
                rm.obj = i
                arr.append(rm)
            }
            
            k += 1
            
        }
        
        self.topCellArr[0] = arr
        self.topMenu.items = self.topCellArr
        
        
    }
    
    
    func putCate(o:Any)
    {
        var arr:[ReactionMenuItemModel] = []
        var k = 0
        for model in o as! [TuanCateModel]
        {
            let rm = ReactionMenuItemModel()
            rm.id = model.id
            rm.sid = "\(model.id)"
            rm.title = model.name
            rm.pid = k
            arr.append(rm)
            
            if model.id == cate_id.numberValue.intValue
            {
                topMenu.titles[1] = model.name
                topMenu.collection.reloadData()
            }
            
            for i in model.bcate_type
            {
                let rm = ReactionMenuItemModel()
                rm.id = i.id
                rm.title = i.name
                rm.level = 1
                rm.fid = k
                rm.obj = i
                arr.append(rm)
                
                
                
            }
            
            k += 1
            
        }
        
        self.topCellArr[1] = arr
        self.topMenu.items = self.topCellArr
        
        
    }
    
    
    func putOrder(o:Any)
    {
        var arr:[ReactionMenuItemModel] = []
        
        for model in o as! [TuanNavModel]
        {
            let rm = ReactionMenuItemModel()
            rm.id = 0
            rm.sid = model.code
            rm.title = model.name
            rm.obj = model
            arr.append(rm)
            
        }
        
        self.topCellArr[2] = arr
        self.topMenu.items = self.topCellArr
        
        
    }
    
    
    func ReactionMenuChoose(_ arr: Array<ReactionMenuItemModel>, index: Int) {
        
        
        if(index == 0)
        {
            if let m = arr.last?.obj as? QuanSubBean
            {
                nowQuan = m
            }
        }
        else if(index == 1)
        {
            if let m = arr.last?.obj as? BcateTypeBean
            {
                nowCate = m
            }
        }
        else
        {
            if let m = arr.last?.obj as? TuanNavModel
            {
                nowOrder = m
            }
        }
        
        tableview.httpHandle.reSet()
        var url = Api.BaseUrl+"?ctl=stores&act=app_index&r_type=1&isapp=true"
        
        url += "&page=[page]"
        url += "&city_id="+DataCache.Share.city.id
        url += "&cate_id=\(nowCate.cate_id)"
        url += "&tid=\(nowCate.id)"
        url += "&qid=\(nowQuan.id)"
        url += "&order_type="+nowOrder.code
        url += "&xpoint=\(XPosition.Share.postion.longitude)"
        url += "&ypoint=\(XPosition.Share.postion.latitude)"
        
        tableview.httpHandle.url = url
        
        tableview.httpHandle.handle()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TabIndex = 1
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
    
    
}
