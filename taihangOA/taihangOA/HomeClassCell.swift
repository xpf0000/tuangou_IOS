//
//  HomeClassCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class HomeClassCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    var model:IndexsBean = IndexsBean()
    {
        didSet
        {
            let u = URL(string: model.img)
            img.kf.setImage(with: u)
            
            name.text = model.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
