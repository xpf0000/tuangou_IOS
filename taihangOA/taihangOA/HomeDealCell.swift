//
//  HomeDealCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/9.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class HomeDealCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var tprice: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var num: UILabel!
    
    
    var model:DealListBean = DealListBean()
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

}
