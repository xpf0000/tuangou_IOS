//
//  StoresCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class StoresCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var star: XStarView!
    
    
    
    var model:StoresModel = StoresModel()
    {
        didSet
        {
            img.kf.setImage(with: model.preview.url())
            
            name.text = model.name
            distance.text = "\(model.distance)"
            address.text = model.address
            
            star.num = model.avg_point.numberValue.intValue
            
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
            
            let url = "http://tg01.sssvip.net/wap/index.php?ctl=store&act=app_index&data_id="+model.id
            
            if let u = url.url()
            {
                vc.url = u
            }
            
            vc.hideNavBar = true

            self.viewController?.show(vc, sender: nil)
            
        }
    }
    

    
}
