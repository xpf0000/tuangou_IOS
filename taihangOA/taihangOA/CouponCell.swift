//
//  CouponCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/14.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {

    @IBOutlet weak var deal_icon: UIImageView!
    @IBOutlet weak var deal_name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var pass: UILabel!
    @IBOutlet weak var code_icon: UIImageView!
    @IBOutlet weak var code_view: UIView!
    
    var name = ""
    
    var model:CouponModel = CouponModel()
    {
        didSet
        {
            code_icon.kf.setImage(with: model.qrcode.url())
            deal_name.text = name
            let str = model.end_time == "0" ? "无过期时间" : model.end_time
            
            time.text = "有效期至："+str
            
            pass.text = model.password
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        code_view.layer.borderColor = "eeeeee".color().cgColor
        code_view.layer.borderWidth = 1.0
        code_view.layer.cornerRadius = 2.0
        code_view.layer.masksToBounds = true
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
