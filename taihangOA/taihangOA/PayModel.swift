//
//  PayModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class PayModel: Reflect {
    
    var order_id = 0
    var  order_sn = ""
    var pay_status = 0
    var  payment_code:PaymentCodeBean = PaymentCodeBean()
    
    var  pay_info = ""
    var couponlist:[CouponModel] = []
    
    
    
    class PaymentCodeBean : Reflect{
        
        
        var  pay_info = ""
        var  payment_name = ""
        var pay_money = 0.00
        var  class_name = ""
        var  config:ConfigBean = ConfigBean()
        
        
        class ConfigBean : Reflect {
            
            var  subject = ""
            var  body = ""
            var total_fee = 0.00
            var  total_fee_format = ""
            var  out_trade_no = ""
            var  notify_url = ""
            var payment_type = 0
            var  service = ""
            var  _input_charset = ""
            var  partner = ""
            var  seller_id = ""
            var  order_spec = ""
            var  sign = ""
            var  sign_type = ""
            
            var  appid = ""
            var  noncestr = ""
            
            var  partnerid = ""
            var prepayid = ""
            var timestamp = 0
            var  ios:IosBean = IosBean()
            var  packagevalue = ""
            var  key = ""
            var  secret = ""
            
            class IosBean : Reflect {
                
                var  appid = ""
                var  noncestr = ""
                var  partnerid = ""
                var prepayid = ""
                var timestamp = 0
                var  sign = ""
                
            }
        }
    }
    
}
