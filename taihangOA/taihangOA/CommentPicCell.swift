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
    
    var model:AnyObject?
    {
        didSet
        {
            if let str = model as? String
            {
                if str.has("http://") || str.has("https://")
                {
                    img.kf.setImage(with: str.url())
                }
                else
                {
                    img.image = str.image()
                }
            }
            else if let m = model as? UIImage
            {
                img.image = m
            }
  
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
