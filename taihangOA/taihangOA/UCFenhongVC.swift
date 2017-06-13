//
//  UCFenhongVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class UCFenhongVC: UITableViewController,UIWebViewDelegate {
    
    @IBOutlet weak var count: UILabel!
    
    @IBOutlet weak var deal_count: UILabel!
    
    @IBOutlet weak var tj_user_count: UILabel!
    
    @IBOutlet weak var tj_shop_count: UILabel!
    
    @IBOutlet weak var web: UIWebView!
    
    var harr:[CGFloat] = [12,55,55,55,55,50,0]
    
    
    var model:UserFenhongModel = UserFenhongModel()
    {
        didSet
        {
            count.text = model.count
            deal_count.text = model.xiaofei
            tj_user_count.text = model.tjuser
            tj_shop_count.text = model.tjshop
            
            let str = BaseHtml.replace("[XHTMLX]", with: model.content)
            
            web.loadHTMLString(str, baseURL: nil)
            
            web.sizeToFit()
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的分红"
        self.addBackButton()
        
        web.scrollView.showsHorizontalScrollIndicator = false
        web.scrollView.showsVerticalScrollIndicator = false
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        getData()
        
    }
    
    func getData()
    {
        let uid = DataCache.Share.User.id
      
        Api.user_fenhongCount(uid: uid) { [weak self] (m) in
        
            self?.model = m

        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3
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
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return harr[indexPath.row]
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        let size = webView.sizeThatFits(CGSize.zero)
        
        harr[6] = size.height
        web.layoutIfNeeded()
        web.setNeedsLayout()
        web.scrollView.isScrollEnabled = false
        tableView.reloadData()
        
    }
    
    
}
