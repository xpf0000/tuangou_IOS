//
//  CommentPicCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CommentPicCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    var model:String = ""
    {
        didSet
        {
            if model.has("http://") || model.has("https://")
            {
                img.kf.setImage(with: model.url())
            }
            else
            {
                img.image = model.image()
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
