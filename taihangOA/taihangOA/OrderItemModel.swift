//
//  OrderItemModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class OrderItemModel: Reflect {

    var  id = ""
    var  order_sn = ""
    var  order_status = ""
    var  pay_status = ""
    var  create_time = ""
    var pay_amount = 0.00
    var total_price = 0.00
    
    var payment_id = 0
    var account_money = 0.00
    var need_pay_price = 0.00
    
    var c = 0
    var  item_id = ""
    var  deal_id = ""
    var  deal_icon = ""
    var  name = ""
    var  sub_name = ""
    var  number = ""
    var unit_price = 0.00
    var consume_count = 0
    var dp_id = 0
    var delivery_status = 0
    var is_arrival = 0
    var is_refund = 0
    var refund_status = 0
    var  status = ""
    
}
