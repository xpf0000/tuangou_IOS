//
//  Api.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias ApiBlock<T> = (T)->Void

class Api: NSObject {
    
    static let BaseUrl  = "http://tg01.sssvip.net/mapi/"
    static let Pagesize = 10
    
    
    class func city_app_index(block:@escaping ApiBlock<CityModel>)
    {
        let url = BaseUrl+"?ctl=city&act=app_index&r_type=1&isapp=true"
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = CityModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }

    }
    
    
    
    class func city_city_change(city_id:String, block:@escaping ApiBlock<Bool>)
    {
        let url = BaseUrl+"?ctl=city&act=city_change&r_type=1&isapp=true&city_id="+city_id
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if let status = json["status"].int
                {
                    block(status == 1)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    class func app_index(city_id:String, xpoint:String, ypoint:String, block:@escaping ApiBlock<HomeModel>)
    {
        let url = BaseUrl+"?ctl=index&act=app_index&r_type=1&isapp=true&city_id="+city_id+"&xpoint="+xpoint+"&ypoint="+ypoint
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = HomeModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func sms_send_code(mobile:String, block:@escaping ApiBlock<Bool>)
    {
        let url = BaseUrl+"?ctl=sms&act=send_sms_code&r_type=1&isapp=true&unique=1&mobile="+mobile
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if let status = json["status"].int
                {
                    block(status == 1)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    class func check_sms_code(mobile:String, code:String,block:@escaping ApiBlock<Bool>)
    {
        let url = BaseUrl+"?ctl=sms&act=check_sms_code&r_type=1&isapp=true&unique=1&mobile="+mobile+"&code="+code
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if let status = json["status"].int
                {
                    block(status == 1)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_doregist(mobile:String, pass:String, code:String, tj:String, block:@escaping ApiBlock<UserModel>)
    {
        var url = BaseUrl+"?ctl=user&act=app_doregister&r_type=1&isapp=true"
        url += "&mobile="+mobile
        url += "&pass="+pass
        url += "&code="+code
        url += "&tj="+tj
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = UserModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    class func user_dologin(user_key:String, user_pwd:String, block:@escaping ApiBlock<UserModel>)
    {
        var url = BaseUrl+"?ctl=user&act=dologin&r_type=1&isapp=true"
        url += "&user_key="+user_key
        url += "&user_pwd="+user_pwd
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = UserModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_getUinfo(uid:String, uname:String, block:@escaping ApiBlock<UserModel>)
    {
        var url = BaseUrl+"?ctl=user&act=getUinfo&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&uname="+uname
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = UserModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_getRenzhenginfo(uid:String, block:@escaping ApiBlock<RenzhengModel>)
    {
        var url = BaseUrl+"?ctl=user&act=getRenzhenginfo&r_type=1&isapp=true"
        url += "&uid="+uid
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = RenzhengModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_getUnitsInfo(uid:String, uname: String , block:@escaping ApiBlock<UserUnitsModel>)
    {
        var url = BaseUrl+"?ctl=user&act=getUnitsInfo&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&uname="+uname
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = UserUnitsModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_fenhongCount(uid:String , block:@escaping ApiBlock<UserFenhongModel>)
    {
        var url = BaseUrl+"?ctl=user&act=fenhongCount&r_type=1&isapp=true"
        url += "&uid="+uid
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = UserFenhongModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_collectlist(uid:String ,page:String , block:@escaping ApiBlock<UserCollectModel>)
    {
        var url = BaseUrl+"?ctl=uc_collect&act=app_index&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = UserCollectModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_commentlist(uid:String ,page:String , block:@escaping ApiBlock<UserCommentModel>)
    {
        var url = BaseUrl+"?ctl=uc_review&act=app_index&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = UserCommentModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

    
    
    class func tuan_index(page:String ,city_id:String ,cate_id:String ,tid:String ,qid:String ,order_type:String ,xpoint:String ,ypoint:String , block:@escaping ApiBlock<NearbyModel>)
    {
        var url = BaseUrl+"?ctl=tuan&act=app_index&r_type=1&isapp=true"
        url += "&page="+page
        url += "&city_id="+city_id
        url += "&cate_id="+cate_id
        url += "&tid="+tid
        url += "&qid="+qid
        url += "&order_type="+order_type
        url += "&xpoint="+xpoint
        url += "&ypoint="+ypoint
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = NearbyModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func stores_list(page:String ,city_id:String ,cate_id:String ,tid:String ,qid:String ,order_type:String ,xpoint:String ,ypoint:String , block:@escaping ApiBlock<StoresListModel>)
    {
        var url = BaseUrl+"?ctl=stores&act=app_index&r_type=1&isapp=true"
        url += "&page="+page
        url += "&city_id="+city_id
        url += "&cate_id="+cate_id
        url += "&tid="+tid
        url += "&qid="+qid
        url += "&order_type="+order_type
        url += "&xpoint="+xpoint
        url += "&ypoint="+ypoint
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = StoresListModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    class func stores_search(page:String ,city_id:String ,keyword:String ,xpoint:String ,ypoint:String , block:@escaping ApiBlock<StoresListModel>)
    {
        var url = BaseUrl+"?ctl=stores&act=app_index&r_type=1&isapp=true"
        url += "&page="+page
        url += "&city_id="+city_id
        url += "&keyword="+keyword
        url += "&xpoint="+xpoint
        url += "&ypoint="+ypoint
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = StoresListModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func tuan_search(page:String ,city_id:String ,keyword:String ,xpoint:String ,ypoint:String , block:@escaping ApiBlock<NearbyModel>)
    {
        var url = BaseUrl+"?ctl=tuan&act=app_index&r_type=1&isapp=true"
        url += "&page="+page
        url += "&city_id="+city_id
        url += "&keyword="+keyword
        url += "&xpoint="+xpoint
        url += "&ypoint="+ypoint
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = NearbyModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func tuan_nav_list(block:@escaping ApiBlock<[TuanNavModel]>)
    {
        var url = BaseUrl+"?ctl=tuan&act=nav_list&r_type=1&isapp=true"
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [TuanNavModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = TuanNavModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func tuan_cate_list(block:@escaping ApiBlock<[TuanCateModel]>)
    {
        var url = BaseUrl+"?ctl=tuan&act=nav_list&r_type=1&isapp=true"
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [TuanCateModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = TuanCateModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func tuan_quan_list(block:@escaping ApiBlock<[TuanQuanModel]>)
    {
        var url = BaseUrl+"?ctl=tuan&act=quan_list&r_type=1&isapp=true"
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [TuanQuanModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = TuanQuanModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

    
    
    class func do_collect(uid:String,id:String, block:@escaping ApiBlock<Bool>)
    {
        var url = BaseUrl+"?ctl=deal&act=app_do_collect&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&id="+id
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if let status = json["status"].int
                {
                    block(status == 1)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    class func deal_info(id:String, block:@escaping ApiBlock<TuanModel>)
    {
        var url = BaseUrl+"?ctl=deal&act=app_info&r_type=1&isapp=true"
        url += "&id="+id
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = TuanModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_money(uid:String, uname:String,block:@escaping ApiBlock<String>)
    {
        var url = BaseUrl+"?ctl=user&act=money&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&uname="+uname
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                block(json["data"].stringValue)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func uc_coupon_info(uid:String, oid:String,block:@escaping ApiBlock<[CouponModel]>)
    {
        var url = BaseUrl+"?ctl=uc_coupon&act=info&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&oid="+oid
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [CouponModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = CouponModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    class func uc_do_refund(uid:String,content:String,item_id:String, block:@escaping ApiBlock<Bool>)
    {
        var url = BaseUrl+"?ctl=uc_order&act=app_do_refund_coupon&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&content="+content
        url += "&item_id="+item_id
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if let status = json["status"].int
                {
                    block(status == 1)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func news_all_cate(block:@escaping ApiBlock<[NewsCateModel]>)
    {
        var url = BaseUrl+"?ctl=news&act=all_type&r_type=1&isapp=true"
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [NewsCateModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = NewsCateModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    class func news_list(tid:String, page:String, block:@escaping ApiBlock<[NewsModel]>)
    {
        var url = BaseUrl+"?ctl=news&act=getList&r_type=1&isapp=true"
        url += "&tid="+tid
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [NewsModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = NewsModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    class func notice_list(page:String, block:@escaping ApiBlock<NoticeModel>)
    {
        var url = BaseUrl+"?ctl=notice&act=index&r_type=1&isapp=true"
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let model = NoticeModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    
    class func do_order_pay(
                            city_id:String,
                            payment:String,
                            all_account_money:String,
                            did:String,
                            uid:String,
                            uname:String,
                            num:String,
                            tprice:String,
                            block:@escaping ApiBlock<PayModel>)
    {
        var url = BaseUrl+"?ctl=cart&act=app_done&r_type=1&isapp=true"
        url += "&city_id="+city_id
        url += "&payment="+payment
        url += "&all_account_money="+all_account_money
        url += "&did="+did
        url += "&uid="+uid
        url += "&uname="+uname
        url += "&num="+num
        url += "&tprice="+tprice
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let model = PayModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func uc_order_pay(
        oid:String,
        uid:String,
        block:@escaping ApiBlock<PayModel>)
    {
        var url = BaseUrl+"?ctl=uc_order&act=do_pay&r_type=1&isapp=true"
        url += "&oid="+oid
        url += "&uid="+uid
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let model = PayModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    
    class func user_orderlist(
        uid:String,
        status:String,
        page:String,
        block:@escaping ApiBlock<OrderModel>)
    {
        var url = BaseUrl+"?ctl=uc_order&act=app_index&r_type=1&isapp=true"
        url += "&uid="+uid
        url += "&status="+status
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let model = OrderModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }


    class func user_add_dp(data:[String:Any],block:@escaping ApiBlock<Bool>)
    {
        
        let url = BaseUrl+"?ctl=dp&act=app_add_dp&r_type=1&isapp=true"
        
        Alamofire.upload(multipartFormData: { (body) in
            
            for (key,value) in data
            {
                if let str = value as? String
                {
                    body.append(str.data(using: String.Encoding.utf8)!, withName: key)
                }
                
                if let d = value as? Data
                {
                    body.append(d, withName: "file[]", fileName: key, mimeType: "image/jpeg")
                }
                
            }
            
        }, to: url) { (res) in
            
            switch res {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        let json = JSON(value)
                        if let status = json["status"].int
                        {
                            block(status == 1)
                        }
                        
                    case .failure(let error):
                        
                        debugPrint(error)
                        
                    }
                    
                    debugPrint(response)
                    
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
        
        
        print(url)
        
    }
    
    
    class func user_do_renzheng(data:[String:Any],block:@escaping ApiBlock<Bool>)
    {
        
        let url = BaseUrl+"?ctl=uc_account&act=do_renzheng&r_type=1&isapp=true"
        
        Alamofire.upload(multipartFormData: { (body) in
            
            var i = 0
            
            for (key,value) in data
            {
                if let str = value as? String
                {
                    body.append(str.data(using: String.Encoding.utf8)!, withName: key)
                }
                
                if let d = value as? Data
                {
                    let str = i == 0 ? "file" : "file1"
                    
                    body.append(d, withName: str, fileName: key, mimeType: "image/jpeg")
                }
                
                i += 1
                
            }
            
        }, to: url) { (res) in
            
            switch res {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        let json = JSON(value)
                        if let status = json["status"].int
                        {
                            block(status == 1)
                        }
                        
                    case .failure(let error):
                        
                        debugPrint(error)
                        
                    }
                    
                    debugPrint(response)
                    
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
        
        
        print(url)
        
    }
    
    
    
    class func app_upload_avatar(data:[String:Any],block:@escaping ApiBlock<Bool>)
    {
        
        let url = BaseUrl+"?ctl=uc_account&act=app_upload_avatar&r_type=1&isapp=true"
        
        Alamofire.upload(multipartFormData: { (body) in
            
            var i = 0
            
            for (key,value) in data
            {
                if let str = value as? String
                {
                    body.append(str.data(using: String.Encoding.utf8)!, withName: key)
                }
                
                if let d = value as? Data
                {
                    body.append(d, withName: "file", fileName: key, mimeType: "image/jpeg")
                }
                
                i += 1
                
            }
            
        }, to: url) { (res) in
            
            switch res {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        let json = JSON(value)
                        if let status = json["status"].int
                        {
                            block(status == 1)
                        }
                        
                    case .failure(let error):
                        
                        debugPrint(error)
                        
                    }
                    
                    debugPrint(response)
                    
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
        
        
        print(url)
        
    }

    
    

}
