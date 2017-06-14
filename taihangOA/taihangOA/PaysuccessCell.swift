//
//  PaysuccessCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/14.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class PaysuccessCell: UITableViewCell {

    @IBOutlet weak var pass: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    
    var model:CouponModel = CouponModel()
    {
        didSet
        {
            pass.text = model.password
            img.kf.setImage(with: model.qrcode.url())
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
