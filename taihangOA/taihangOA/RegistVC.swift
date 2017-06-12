//
//  RegistVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

var SmsWaitTime:Int = 60

class PostTimeModel: Reflect {
    
    var time:NSNumber = 0.0
    
}

class RegistVC: UITableViewController {

    @IBOutlet weak var tel: UITextField!
    
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var pass1: UITextField!
    @IBOutlet weak var tuijian: UITextField!
    
    @IBOutlet weak var smsbtn: UIButton!
    @IBOutlet weak var checkbtn: UIButton!
    
    var codestr = ""
    
    var timer:Timer?
    var timeModel:PostTimeModel = PostTimeModel()
    var surplusTime:Int = -1
    
    
    @IBAction func to_xieyi(_ sender: Any) {
        
        
    }
    
    
    @IBAction func do_sendsms(_ sender: UIButton) {
        
        if !tel.checkNull()
        {
            return
        }
        
        if !tel.checkPhone()
        {
            return
        }
        XWaitingView.show()
        
        sender.isEnabled = false
        
        let p = tel.text!
        
        Api.sms_send_code(mobile: p) { [weak self](b) in
            if self == nil {return}
            XWaitingView.hide()
            sender.isEnabled = true
            
            if(b)
            {
                self?.timeModel.time = NSNumber.init(value: Date().timeIntervalSince1970)
                _ = PostTimeModel.save(obj: self!.timeModel, name: "SmsPostTime")
                self?.surplusTime = SmsWaitTime
                
                self?.smsbtn.setTitle("\(self!.surplusTime)秒后再次发送", for: .disabled)
                self?.smsbtn.isEnabled = false
                
                self?.timer=Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self!.timeChange), userInfo: nil, repeats: true)
                self?.timer!.fire()

            }
            
            
        }
        
        
    }
    
    @IBAction func do_scan(_ sender: Any) {
        
        let vc = ScannerViewController()
        vc.onScanResult { [weak self](str) in
            
            self?.tuijian.text = str
            
        }
        
        self.show(vc, sender: nil)
        
    }
    
    
    @IBAction func do_regist(_ sender: Any) {
        
        if !tel.checkNull() || !code.checkNull() || !pass.checkNull() || !pass1.checkNull() || !tuijian.checkNull()
        {
            XMessage.show("请完善注册信息")
            return
        }
        
        if(!pass.checkLength("密码", min: 6, max: 18) || !pass1.checkLength("密码", min: 6, max: 18))
        {
            return
        }
        
        if(pass.text!.trim() != pass1.text!.trim())
        {
            XMessage.show("密码和确认密码不一致")
            return
        }
    
        Api.user_doregist(mobile: tel.text!.trim(), pass: pass.text!.trim(), code: code.text!.trim(), tj: tuijian.text!.trim()) {[weak self] (user) in
            
            DataCache.Share.User = user
            DataCache.Share.User.save()
            
            "UserAccountChange".postNotice()
            
            XAlertView.show("注册成功", block: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })

        }
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "会员注册"
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v

        tel.addEndButton()
        code.addEndButton()
        pass.addEndButton()
        pass1.addEndButton()
        tuijian.addEndButton()
        
        tuijian.text = codestr
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row < 10
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

    
    
    
    func initSelf()
    {
        if let m = PostTimeModel.read(name: "SmsPostTime") as? PostTimeModel
        {
            timeModel = m
            
            if(timeModel.time != 0)
            {
                surplusTime = Int(Date().timeIntervalSince1970 - timeModel.time.doubleValue)
                surplusTime = SmsWaitTime-surplusTime
                
                if(surplusTime >= 0)
                {
                    self.timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeChange), userInfo: nil, repeats: true)
                    self.timer!.fire()
                }
                else
                {
                    PostTimeModel.delete(name: "postTime")
                }
                
                
            }
            
            
        }
        
        
       
    }

    
    func timeChange()
    {
        surplusTime -= 1
        if(surplusTime >= 0)
        {
            smsbtn.setTitle("\(surplusTime)秒后再次发送", for: UIControlState.disabled)
            smsbtn.isEnabled = false
        }
        else
        {
            self.timer?.invalidate()
            self.timer = nil
            smsbtn.setTitle("发送验证码", for: .normal)
            smsbtn.isEnabled = true
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initSelf()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

   
}
