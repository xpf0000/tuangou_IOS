//
//  LoginVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var account: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    
    @IBAction func do_login(_ sender: UIButton) {
        
        self.view.endEdit()
        if(!account.checkNull() || !pass.checkNull())
        {
            return
        }
        
        if(!pass.checkLength("密码", min: 6, max: 18))
        {
            return
        }
        
        let ukey = account.text!
        let upass = pass.text!
        
        Api.user_dologin(user_key: ukey, user_pwd: upass) { [weak self](user) in
            
            DataCache.Share.User = user
            DataCache.Share.User.save()
            
            "UserAccountChange".postNotice()
            
            XAlertView.show("登录成功", block: {[weak self] in
                
                self?.pop()
                
            })
            
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        account.addEndButton()
        pass.addEndButton()
        
        let button=UIButton(type: UIButtonType.custom)
        button.frame=CGRect(x: 0, y: 0, width: 50, height: 21);
        button.setTitle("注册", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isExclusiveTouch = true
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        button.click {[weak self] (btn) in
            
            self?.to_regist()
            
        }
        
        
    }
    
    
    func to_regist()
    {
        let vc = "RegistVC".VC(name: "Main")
        self.show(vc, sender: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
