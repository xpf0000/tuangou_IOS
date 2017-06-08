//
//  HomeModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class HomeModel: Reflect {

    var  city_id = ""
    var  city_name = ""
    var  page_title = ""
    var indexs:[IndexsBean] = []
    var deal_list:[DealListBean] = []
    var zt_html:[ZtHtmlBean] = []
    
    class IndexsBean:Reflect {

        var  id = ""
        var  name = ""
        var  img = ""
        var  icon_name = ""
        var  color = ""
        var  data:DataBean = DataBean()
        var  ctl = ""
        var  type = ""
        
        class DataBean:Reflect {
            var  cate_id = ""
            var  url = ""
            var  data_id = ""
        }
    }
    
    class DealListBean:Reflect {
    
        var  id = ""
        var distance = 0.00
        var ypoint = 0.00
        var xpoint = 0.00
        var  name = ""
        var  sub_name = ""
        var  brief = ""
        var  buy_count = ""
        var current_price = 0.00
        var origin_price = 0.00
        var  icon = ""
        var  icon_v1 = ""
        var  end_time_format = ""
        var  begin_time_format = ""
        var  begin_time = ""
        var  end_time = ""
        var  auto_order = ""
        var  is_lottery = ""
        var  is_refund = ""
        var deal_score = 0
        var buyin_app = 0
        var allow_promote = 0
        var location_id = 0
        var is_today = 0
        
    }
    
    class ZtHtmlBean:Reflect {
        
        var  id = ""
        var  name = ""
        var  img = ""
        var  mobile_type = ""
        var  type = ""
        var  position = ""
        var  data:DataBeanX = DataBeanX()
        var  sort = ""
        var  status = ""
        var  city_id = ""
        var  ctl = ""
        var  zt_id = ""
        var  zt_position = ""
        var  url = ""

        class DataBeanX:Reflect {

            var  cate_id = ""
            var  url = ""
            var  data_id = ""
  
        }
    }
    
    
}
