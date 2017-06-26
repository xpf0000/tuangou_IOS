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
            
            let a = XPosition.Share.postion.latitude > 0.0 && XPosition.Share.postion.longitude > 0.0
            let b = model.xpoint > 0.0 && model.ypoint > 0.0
            if(a && b)
            {
                let point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(XPosition.Share.postion.latitude,XPosition.Share.postion.longitude));
                
                let point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(model.ypoint,model.xpoint));
                
                var dis = BMKMetersBetweenMapPoints(point1,point2);
                
                if dis > 1000
                {
                    dis = dis / 1000.0
                    let s = String.init(format: "%.1fkm", dis)
                    distance.text = s
                }
                else
                {
                    distance.text = "\(dis)m"
                }
                
            }
            else
            {
                distance.text = "\(model.distance)"
            }
            
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
