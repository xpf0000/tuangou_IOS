//
//  CollectCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CollectCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var tprice: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var num: UILabel!
    
    
    var model:GoodsListBean = GoodsListBean()
    {
        didSet
        {
            let url = URL.init(string: model.icon)
            img.kf.setImage(with: url)
            
            name.text = model.sub_name
            time.text = model.end_time
            tprice.text = "￥\(model.current_price)"
            price.text = "￥\(model.origin_price)"
            
            num.text  = model.buy_count
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
