//
//  PaySuccessVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/14.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class PaySuccessVC: UIViewController {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var num: UILabel!
    
    @IBOutlet weak var nameView: XRoundView!
    
    @IBOutlet weak var table: XTableView!
    
    var tuanModel:TuanModel?
    var payModel:PayModel?
    
    override func pop() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付结果"
        self.addBackButton()
        
        let cm1 = XCornerRadiusModel()
        cm1.FillPath = true
        cm1.FillColor = APPBlueColor
        
        cm1.CornerRadius=6.0
        
        cm1.CornerRadiusType = [.topRight,.topLeft]
        
        nameView.XCornerRadius = cm1
        
        table.contentInset.bottom = 20
        
        table.cellHeight = 100
        
        if let oid = payModel?.order_id
        {
            var url = Api.BaseUrl+"?ctl=uc_coupon&act=info&r_type=1&isapp=true"
            url += "&oid=\(oid)"
            url += "&uid="+DataCache.Share.User.id

            table.setHandle(url, pageStr: "[page]", keys: ["data"], model: CouponModel.self, CellIdentifier: "PaysuccessCell")
            
            table.httpHandle.BeforeBlock({[weak self] (arr) in
                
                self?.num.text = "\(arr.count)张"
                
            })
            
            table.show()
        }
        
        if let m = tuanModel
        {
            name.text = m.sub_name
        }

        
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
    
}
