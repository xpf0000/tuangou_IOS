//
//  UCOrderPayVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import SwiftyJSON


class UCOrderPayVC: UITableViewController,UIAlertViewDelegate {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var submit_btn: UIButton!
    
    @IBOutlet weak var tprice: UILabel!
    
    @IBOutlet weak var yprice: UILabel!
    
    @IBOutlet weak var dprice: UILabel!
    
    
    var oid = ""
    var name_str = ""
    var paytype = 0
    var tprice_num = 0.0
    var cprice_num = 0.0
    var nprice_num = 0.0
    
    var harr:[CGFloat] = [12,100,30,65,65,50,50,50,80]
    
    var payModel:PayModel?
    
    @IBAction func do_submit(_ sender: UIButton) {
        
        submit_btn.isEnabled = false
        
        XWaitingView.show()
        
        if payModel != nil
        {
            doPay()
        }
        
        let uid = DataCache.Share.User.id
        
        Api.uc_order_pay(oid: oid, uid: uid) {[weak self] (paymodel) in
            
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
            
            AlipaySDK.defaultService().payOrder(str, fromScheme: appScheme, callback: {[weak self] (dic) in
                
                var resultStatus = 0
                
                if let s = dic?["resultStatus"] as? String
                {
                    resultStatus = s.numberValue.intValue
                }
                else
                {
                    if let o = dic
                    {
                        var str = ""
                        for (k,v) in o
                        {
                            str += k as! String
                            str += v as! String
                        }
                        
                        let t = str.removingPercentEncoding ?? ""
                        let json = JSON.init(parseJSON: t)
                        
                        resultStatus = json["memo"]["ResultStatus"].intValue
                    }
                    
                }
                
                
                if(resultStatus == 9000)
                {
                    self?.handlePayResult(0)
                }
                else if(resultStatus == 6001)
                {
                    self?.handlePayResult(2)
                }
                else if(resultStatus == 8000)
                {
                    self?.handlePayResult(3)
                }
                else
                {
                    var memo = dic?["memo"] as? String
                    memo = memo == nil ? "" : memo
                    memo = memo == "" ? "支付失败" : memo
                    
                    print(memo ?? "")
                    
                    self?.handlePayResult(1)
                    
                }
                
            })
        }
        
        
        
        
    }
    
    
    
    func wxPayResult( _ notif:NSNotification)
    {
        //支付成功!支付取消!支付失败!请重新支付!
        let m = notif.object
        
        if let message = m as? String
        {
            switch message{
            case "支付成功!":
                handlePayResult(0)
            case "支付取消!":
                handlePayResult(2)
            case "支付失败!请重新支付!":
                handlePayResult(1)
            default:
                break
            }
        }
        
        
    }

    
    func doWXPay()
    {
        
        if !WXApi.isWXAppInstalled()
        {
            XWaitingView.hide()
            XMessage.show("检测到未安装微信，无法支付")
            return
        }
        
        if !WXApi.isWXAppSupport()
        {
            XWaitingView.hide()
            XMessage.show("微信版本过低，请先升级微信至最新版")
            return
        }
        
        if let m = payModel?.payment_code.config.ios
        {
            
            let req:PayReq = PayReq()
            req.openID = m.appid
            req.partnerId = m.partnerid
            req.prepayId = m.prepayid
            req.package = m.package
            req.nonceStr = m.noncestr
            req.timeStamp  = m.timestamp
            req.sign = m.sign
            WXApi.send(req)
            
            NotificationCenter.default.addObserver(self, selector: #selector(wxPayResult(_:)), name: NSNotification.Name(rawValue: "weixin_pay_result"), object: nil)
            
        }

    }
    
    func handlePayResult(_ status:Int)
    {
        XWaitingView.hide()
        
        if(status == 0)
        {
            "OrderNeedRefresh".postNotice()
            XAlertView.show("支付成功！", block: { [weak self] in
                
                let vc = "PaySuccessVC".VC(name: "Main") as! PaySuccessVC
                vc.tuanModel = TuanModel()
                vc.tuanModel?.sub_name = self!.name_str
                
                self?.payModel?.order_id = self!.oid.numberValue.intValue
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
        else
        {
            submit_btn.isEnabled = true
        }
        
    }
    
    func show()
    {
        
        name.text = name_str
        price.text = "￥\(tprice_num)"
        
        tprice.text = "￥\(tprice_num)"
        yprice.text = "￥\(cprice_num)"
        dprice.text = "￥\(nprice_num)"
        
        if paytype == 20
        {
            harr[4] = 0.0
        }
        else
        {
            harr[3] = 0.0
        }
        
        submit_btn.setTitle("确认支付(\(nprice_num)元)", for: .normal)
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "提交订单"
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        show()
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return harr[indexPath.row]
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset=UIEdgeInsetsMake(0, SW, 0, 0)
        cell.layoutMargins=UIEdgeInsetsMake(0, SW, 0, 0)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

