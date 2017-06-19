//
//  APPSetupVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Kingfisher

class APPSetupVC: UITableViewController,UIAlertViewDelegate {

    let logoutAlert = UIAlertView()
    
    @IBOutlet weak var ustatus: UILabel!
    
    @IBOutlet weak var caches: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    
    @IBAction func btn_click(_ sender: Any) {
        
        if DataCache.Share.User.id == ""
        {
            
        }
        else
        {
            logoutAlert.delegate = self
            logoutAlert.title = "注销登录"
            logoutAlert.message = "确定要登出账户吗?"
            logoutAlert.addButton(withTitle: "取消")
            logoutAlert.addButton(withTitle: "确定")
            logoutAlert.show()
        }
        
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1
        {
            
            DataCache.Share.User = UserModel()
            DataCache.Share.User.save()
            
            "UserAccountChange".postNotice()
            
            initUI()
            
        }
        
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "设置"
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if indexPath.row == 2
       {
        
            KingfisherManager.shared.cache.clearDiskCache()
            caches.text = "0.0MB"
        
        }
        else if indexPath.row == 3
       {
            if !checkIsLogin()
            {
                return
            }
        
            let vc = HtmlVC()
            vc.url = "http://www.tcbjpt.com/wap/index.php?ctl=user&act=app_getpassword&mobile=\(DataCache.Share.User.user_name)".url()
            vc.title = "找回密码"
            self.show(vc, sender: nil)
        
       }
        else if indexPath.row == 5
       {
            let vc = "AboutVC".VC(name: "Main")
            self.show(vc, sender: nil)
        }
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, SW, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, SW, 0, 0)
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        tableView.separatorInset=UIEdgeInsets.zero
        tableView.layoutMargins=UIEdgeInsets.zero
        
    }
    
    func initUI()
    {
        if DataCache.Share.User.id == ""
        {
            ustatus.text = "未登录"
        }
        else
        {
            if(DataCache.Share.User.is_effect == 1)
            {
                ustatus.text = "已认证"
            }
            else
            {
                ustatus.text = "未认证"
            }
        }
        
        let size = KingfisherManager.shared.cache.diskCachePath.CachesSize()
        
        caches.text = String(format: "%.2fM", size/1024.0/1024.0)
        
        btn.isSelected = DataCache.Share.User.id != ""
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}
