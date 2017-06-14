//
//  OrderPayVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/14.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderPayVC: UITableViewController,UIAlertViewDelegate {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var wxcheck: UIButton!
    
    @IBOutlet weak var alicheck: UIButton!
    
    @IBOutlet weak var yutxt: UILabel!
    
    @IBOutlet weak var yucheck: UIButton!
    
    @IBOutlet weak var submit_btn: UIButton!
    
    @IBAction func check_click(_ sender: UIButton) {
        
        if sender == wxcheck
        {
            wxcheck.isSelected = true
            alicheck.isSelected = false
        }
        else if sender == alicheck
        {
            wxcheck.isSelected = false
            alicheck.isSelected = true
        }
        else
        {
            yucheck.isSelected = !yucheck.isSelected
            
            if yucheck.isSelected
            {
                var p = tuanModel.total_price - umoney
                p = p < 0 ? 0 : p
                
                submit_btn.setTitle("确认支付(\(p)元)", for: .normal)
                
            }
            else
            {
                submit_btn.setTitle("确认支付(\(tuanModel.total_price)元)", for: .normal)
            }
            
        }
        
    }
    
    var tuanModel = TuanModel()
    
    var umoney:Double = 0.0
     {
        didSet
        {
            if umoney == 0.0
            {
                harr[5] = 0
                harr[6] = 0
            }
            else
            {
                harr[5] = 50
                harr[6] = 65
                
                yutxt.text = "当前账户余额：\(umoney)元，使用余额支付"
                
            }
            
            tableView.reloadData()
            
        }
    }
    
    var harr:[CGFloat] = [12,100,60,65,65,0,0,80]

    var payModel:PayModel?
    
    @IBAction func do_submit(_ sender: UIButton) {
        
        submit_btn.isEnabled = false
        
        XWaitingView.show()
        
        if payModel != nil
        {
            doPay()
        }
        
        let city_id = DataCache.Share.city.id
        let uid = DataCache.Share.User.id
        let uname = DataCache.Share.User.user_name
        let did = tuanModel.id
        let num = "\(tuanModel.num)"
        let tprice = "\(tuanModel.total_price)"
        
        let all_account_money = yucheck.isSelected ? "1" : "0"
        let payment = wxcheck.isSelected ? "20" : "21"
        
        Api.do_order_pay(city_id: city_id, payment: payment, all_account_money: all_account_money, did: did, uid: uid, uname: uname, num: num, tprice: tprice) {[weak self] (paymodel) in

            self?.yucheck.isUserInteractionEnabled = false
            self?.payModel = paymodel
            
            self?.doPay()
            
            
        }
        
        
        
        
    }
    
    
    func doPay()
    {
        
        if payModel == nil {return}
        
        //支付完成
        if(payModel?.pay_status == 1)
        {
            handlePayResult(0)
        }
        else
        {
            if payModel?.payment_code.payment_name == "支付宝"
            {
                doAliPay()
            }
            else
            {
                doWXPay()
            }
        }
    
    }
    
    func doAliPay()
    {
        let appScheme = "XTongChengBaiJia"
        
        if let str = payModel?.payment_code.config.order_spec
        {
            
            AlipaySDK.defaultService().payOrder(str, fromScheme: appScheme, callback: {[weak self] (o) in
                
                let  dic = o as NSDictionary? as? [AnyHashable: Any] ?? [:]
                
                var str = ""
                for (k,v) in dic
                {
                    str += k as! String
                    str += v as! String
                }
                
                let t = str.removingPercentEncoding ?? ""
                let json = JSON.init(parseJSON: t)
                
                if let resultStatus = json["memo"]["ResultStatus"].string
                {
                    if(resultStatus.numberValue.intValue == 9000)
                    {
                        self?.handlePayResult(0)
                    }
                    else if(resultStatus.numberValue.intValue == 6001)
                    {
                        self?.handlePayResult(2)
                    }
                    else if(resultStatus.numberValue.intValue == 8000)
                    {
                        self?.handlePayResult(3)
                    }
                    else
                    {
                        var memo = dic["memo"] as? String
                        memo = memo == nil ? "" : memo
                        memo = memo == "" ? "支付失败" : memo
                        
                        print(memo ?? "")
                        
                        self?.handlePayResult(1)
                        
                    }

                }
                else
                {
                    self?.handlePayResult(1)
                }
                
            })
        }
        
        
        
        
    }
    
    func doWXPay()
    {
        
    }
    
    func handlePayResult(_ status:Int)
    {
        XWaitingView.hide()
        
        if(status == 0)
        {
            
            XAlertView.show("支付成功！", block: { [weak self] in
                
                let vc = "PaySuccessVC".VC(name: "Main") as! PaySuccessVC
                vc.tuanModel = self?.tuanModel
                vc.payModel = self?.payModel
                
                vc.hidesBottomBarWhenPushed = true
                
                self?.show(vc, sender: nil)
                
            })
            
        }
        else if(status == 1)
        {
            let alert = UIAlertView()
            alert.delegate = self
            alert.title = "提醒"
            alert.message = "支付失败,是否重试?"
            alert.addButton(withTitle: "取消")
            alert.addButton(withTitle: "确定")
            alert.show()
            
        }
        else if(status == 2)  //取消支付
        {
            XAlertView.show("用户取消支付")
            submit_btn.isEnabled = true
        }
        else if(status == 3) //结果确认中
        {
            XAlertView.show("支付结果确认中,请稍候在订单中心查看", block: { [weak self] in
                
                    self?.pop()
                
            })
        }
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1
        {
            self.doPay()
        }
        
    }
    
    
    func getData()
    {
        let uid = DataCache.Share.User.id
        let uname = DataCache.Share.User.user_name
        
        Api.user_money(uid: uid, uname: uname) {[weak self] (str) in
            
            self?.umoney = str.numberValue.doubleValue.roundDouble()
            
        }
        
    }
    
    func show()
    {
        
        name.text = tuanModel.sub_name
        price.text = "￥\(tuanModel.total_price)"
       submit_btn.setTitle("确认支付(\(tuanModel.total_price)元)", for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "提交订单"
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        show()
        getData()
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return harr[indexPath.row]
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3
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
