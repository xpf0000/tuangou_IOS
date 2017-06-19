//
//  NearbyCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/9.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class NearbyCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var tprice: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var num: UILabel!
    
    
    var model:TuanModel = TuanModel()
    {
        didSet
        {
            let url = URL.init(string: model.icon)
            img.kf.setImage(with: url)
            
            name.text = model.sub_name
            distance.text = "\(model.distance)"
            time.text = model.end_time_format
            tprice.text = "￥\(model.current_price)"
            price.text = "￥\(model.origin_price)"
            
            num.text  = model.buy_count
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected)
        {
            deSelect()
            
            let vc = HtmlVC()
            vc.hidesBottomBarWhenPushed = true
            
            let url = "http://www.tcbjpt.com/wap/index.php?ctl=deal&act=app_index&data_id="+model.id+"&city_id="+DataCache.Share.city.id
            
            if let u = url.url()
            {
                vc.url = u
            }

            vc.hideNavBar = true
            vc.tuanModel = model
            vc.title = "详情"
            
            self.viewController?.show(vc, sender: nil)
            
        }
    }

    
    
}
