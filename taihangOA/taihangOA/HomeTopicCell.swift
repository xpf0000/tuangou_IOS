//
//  HomeTopicCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class HomeTopicCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    var model:ZtHtmlBean = ZtHtmlBean()
    {
        didSet
        {
            let u = URL(string: model.img)
            img.kf.setImage(with: u)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
