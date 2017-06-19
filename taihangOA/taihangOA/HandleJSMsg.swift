//
//  HandleJSMsg.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Hero



class HandleJSMsg: NSObject {

    
    static func handle(obj:JSON,  vc:UIViewController)
{
    let type = obj["type"].intValue
    let msg = obj["msg"].stringValue
    
    print(obj)
  
    if(type == 0)  //url 跳转
    {

        let url = obj["url"].stringValue
        let arr = url.split(".html")
        
        let base = TmpDirURL.appendingPathComponent("\(arr[0]).html")
        if let full = "\(base)\(arr[1])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        {
            let tovc = HtmlVC()
            tovc.baseUrl = TmpDirURL
            tovc.url = URL(string: full)
            
            Hero.shared.setDefaultAnimationForNextTransition(.push(direction: .left))
            Hero.shared.setContainerColorForNextTransition(.lightGray)
            
            vc.present(tovc, animated: true, completion: nil)
        }
    
        
    }
    else if(type == 1)  //返回
    {
        let back = obj["back"].stringValue
        if(back != "")
        {
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "logout")))
        }
        else
        {
            
            if(vc is HtmlVC)
            {
                    (vc as! HtmlVC).dodeinit()
            }
            
            Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
            Hero.shared.setContainerColorForNextTransition(.lightGray)
            
            vc.hero_dismissViewController()

        }
        
    }
    else if(type == 2)  //分享
    {
        let icon = obj["icon"].stringValue
        let name = obj["name"].stringValue
        
        if(vc is HtmlVC)
        {
            (vc as! HtmlVC).doShare(icon: icon, name: name)
        }
        
    }
    else if(type == 3)  //收藏
    {
        if let v = vc as? HtmlVC
        {
            v.doCollect()
        }
    }
    else if(type == 4)  //图文详情
    {
        if let v = vc as? HtmlVC
        {
            v.toPicInfo()
        }

    }
    else if(type == 5)  //其他团购
    {
        let id = obj["id"].intValue
        let nvc = HtmlVC()
        nvc.hidesBottomBarWhenPushed = true
        
        let url = "http://www.tcbjpt.com/wap/index.php?ctl=deal&act=app_index&data_id=\(id)&city_id="+DataCache.Share.city.id
        
        if let u = url.url()
        {
            nvc.url = u
        }
        
        nvc.hideNavBar = true
        nvc.tuanModel.id = "\(id)"
        nvc.title = "详情"
        
        vc.show(nvc, sender: nil)
        
    }
    else if(type == 6)  //点击购买
    {
        if let v = vc as? HtmlVC
        {
            v.doBuy()
        }
    }
    else if(type == 7)  //评价
    {
        
       let did = obj["did"].stringValue
        
        let nvc = "CommentSubmitVC".VC(name: "Main") as! CommentSubmitVC
        
        nvc.data_id = did
        
        vc.show(nvc, sender: nil)
    
    }
    else if(type == 8)  //继续支付
    {
        
        if let v = vc as? HtmlVC
        {
            v.addPopObserver(str: "OrderNeedRefresh")
        }
        
        let vc1 = "UCOrderPayVC".VC(name: "Main") as! UCOrderPayVC
        
        vc1.oid = obj["oid"].stringValue
        vc1.name_str = obj["name"].stringValue
        vc1.paytype = obj["paytype"].intValue
        vc1.tprice_num = obj["tprice"].doubleValue
        vc1.cprice_num = obj["cprice"].doubleValue
        vc1.nprice_num = obj["nprice"].doubleValue
        
        let nv = XNavigationController.init(rootViewController: vc1)
        
        vc.show(nv, sender: nil)
        
        
        
    }
    else if(type == 9)  //去退款
    {
        
        if let v = vc as? HtmlVC
        {
            v.addReloadObserver(str: "DoRefundSuccess")
        }
        
        let id = obj["oid"].intValue
        
        let nvc = HtmlVC()
        nvc.hidesBottomBarWhenPushed = true
        
        let url = "http://www.tcbjpt.com/wap/index.php?ctl=uc_order&" +
            "act=app_refund&id=\(id)&uid="+DataCache.Share.User.id
        
        if let u = url.url()
        {
            nvc.url = u
        }
        
        nvc.title = "申请退款"
        
        vc.show(nvc, sender: nil)

        
    }
    else if(type == 10)  //退款提交
    {
        let uid = DataCache.Share.User.id
        let content = obj["content"].stringValue
        let ids = obj["ids"].stringValue
        
        Api.uc_do_refund(uid: uid, content: content, item_id: ids, block: { (res) in
            
            if res
            {
                "DoRefundSuccess".postNotice()
                "OrderNeedRefresh".postNotice()
                
                XAlertView.show("提交成功，请等待审核", block: {
                    
                    vc.pop()
                    
                })

            }
            
        })
        
        
    }
    
    else if(type == 11)  //其他商家
    {
        let id = obj["id"].intValue
        
        let nvc = HtmlVC()
        nvc.hidesBottomBarWhenPushed = true
        
        let url = "http://www.tcbjpt.com/wap/index.php?ctl=store&act=app_index&data_id=\(id)"
        
        if let u = url.url()
        {
            nvc.url = u
        }
        
        nvc.hideNavBar = true

        vc.show(nvc, sender: nil)
 
    }
    
    else if(type == 12)  //跳转评论页
    {
        let id = obj["id"].intValue
        
        let nvc = HtmlVC()
        nvc.hidesBottomBarWhenPushed = true
        
        let url = "http://www.tcbjpt.com/wap/index.php?ctl=dp_list&act=app_index&type=deal&data_id=\(id)"
        
        if let u = url.url()
        {
            nvc.url = u
        }
        
        nvc.title = "点评列表"
        
        vc.show(nvc, sender: nil)
        
 
    }
    else if type == -1
    {
        XMessage.show(msg)
    }
    
    
    
}
    
}
