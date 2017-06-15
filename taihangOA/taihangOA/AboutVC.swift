//
//  AboutVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class AboutVC: UITableViewController {

    @IBOutlet weak var txt1: UILabel!
    @IBOutlet weak var txt2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
        self.addBackButton()
        
        if let y = Date().toStr("yyyy")
        {
            txt1.text = "同城百家 版权所有 \(y)"
        }
        
        let infoDictionary = Bundle.main.infoDictionary
        
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as AnyObject
    
        let appversion = majorVersion as! String

        txt2.text = "软件版本 v"+appversion
    
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1
        {
            let vc = HtmlVC()
            vc.url = "http://tg01.sssvip.net/index.php?ctl=agent".url()
            vc.title="代理商招募"
            
            self.show(vc, sender: nil)
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        tableView.separatorInset=UIEdgeInsets.zero
        tableView.layoutMargins=UIEdgeInsets.zero
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
}
