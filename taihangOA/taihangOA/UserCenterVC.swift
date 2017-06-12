//
//  UserCenterVC.swift
//  chengshi
//
//  Created by X on 15/11/28.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class UserCenterVC: UITableViewController {
    
    @IBOutlet weak var header: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    

    func showInfo()
    {
        if(DataCache.Share.User.id != "")
        {
            let url = DataCache.Share.User.avatar.url()
            
            header.kf.setImage(with: url, placeholder: "tx.jpg".image(), options: nil, progressBlock: nil, completionHandler: nil)
            
            if(DataCache.Share.User.is_effect == 1)
            {
                name.text = DataCache.Share.User.real_name
            }
            else
            {
                
                if(DataCache.Share.User.rezhenging)
                {
                    name.text = "会员审核中"
                }
                else
                {
                    name.text = "请提交认证"
                }
                
            }
        }
        else
        {
            header.image = "tx.jpg".image()
            name.text = "尚未登录"
        }
        
        
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员中心"
        let view = UIView()
        tableView.tableHeaderView = view
        tableView.tableFooterView = view
        tableView.contentInset.top = 0.0
        tableView.contentInset.bottom = 70.0
            
        header.layer.cornerRadius = 50.0
        header.layer.masksToBounds=true
        
        showInfo()
        
    }
    
    let sarr:[Int] = [2,3,4,5,8]
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if sarr.contains(indexPath.row)
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15)
            cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 15)
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

    let tarr:[Int] = [2,3,4,5,6,8,9]
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tarr.contains(indexPath.row)
        {
            if(!self.checkIsLogin())
            {
                return
            }
        }
        
        switch indexPath.row
        {
        case 2:

           break
        case 3:
            
           break
        case 4:
            
         break
        case 5:
            
           break
            
        case 8:
            
           break
            
        case 6:
            
            break
            
        case 9:
            
           break
            
        case 11: break
            
//            let vc:ConfigVC = "ConfigVC".VC("User") as! ConfigVC
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
            
            
        default :
            break
        }
        
    }
    
    
    func getUinfo()
    {
        if DataCache.Share.User.id == ""
        {
            return
        }
        
        Api.user_getUinfo(uid: DataCache.Share.User.id, uname: DataCache.Share.User.user_name) { [weak self](m) in
            
            DataCache.Share.User = m
            DataCache.Share.User.save()
            
            self?.showInfo()
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUinfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
