//
//  OrderSubmitVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/14.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class OrderSubmitVC: UITableViewController {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var numView: XBuyNumView!
    
    @IBOutlet weak var total_price: UILabel!
    
    @IBAction func do_submit(_ sender: Any) {
        
        if model.current_price == 0.0 || model.origin_price == 0.0
        {
            XAlertView.show("网络错误，请重新提交订单", block: { [weak self] in
                self?.pop()
            })
            
            return
        }
        
        let vc = "OrderPayVC".VC(name: "Main") as! OrderPayVC
        vc.hidesBottomBarWhenPushed = true
        vc.tuanModel = model
        
        self.show(vc, sender: nil)
        
    }
    
    var model = TuanModel()
    
    func getData()
    {
        
        if model.origin_price != 0.0 && model.current_price != 0.0
        {
            show()
        }
        else
        {
            Api.deal_info(id: model.id, block: {[weak self] (m) in
                
                self?.model = m
                self?.show()
                
            })
        }
        
    }
    
    func show()
    {
        
        name.text = model.sub_name
        price.text = "￥\(model.current_price)"
        total_price.text = "￥\(model.current_price)"
        model.total_price = model.current_price
        model.num = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "提交订单"
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        getData()
        
        numView.onNumChange { [weak self](num) in
            
            self?.model.num = num
            self?.model.total_price = Double(num) * self!.model.current_price.roundDouble()
            self?.total_price.text = "￥\(self!.model.total_price)"
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 || indexPath.row == 2
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
}
