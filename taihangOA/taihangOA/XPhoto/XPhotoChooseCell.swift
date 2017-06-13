//
//  XPhotoChooseCell.swift
//  XPhoto
//
//  Created by 徐鹏飞 on 16/9/16.
//  Copyright © 2016年 XPhoto. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

class XPhotoChooseCell: UICollectionViewCell {
    
    let choose = UIButton(type: .custom)
    let img = UIImageView()
    
    weak var asset:XPhotoAssetModel!
    {
        didSet
        {
            show()
        }
    }
    
    fileprivate var  cellW:CGFloat = (SW-25)/4.0
    fileprivate var block:XPhotoChooseAssetBlock?
    
    func doChoose(_ b:@escaping XPhotoChooseAssetBlock)
    {
        block = b
    }


    fileprivate func show()
    {
        
        for item in contentView.subviews
        {
            item.removeFromSuperview()
        }

        choose.isSelected = false
        
        img.contentMode = .scaleAspectFill
        img.frame = CGRect(x: 0, y: 0, width: cellW,height: cellW)
        img.layer.masksToBounds=true
        img.image = asset.image

        contentView.addSubview(img)
        
        choose.frame = CGRect(x: cellW-26-4, y: cellW-26-4, width: 26, height: 26)
        choose.setImage("Checkmark-0@2x.png".image(), for: UIControlState())
        choose.setImage("Checkmark-1@2x.png".image(), for: .selected)
        choose.imageView?.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        choose.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        
        contentView.addSubview(choose)
        
    }
    
    func click(_ sender:UIButton)
    {
        if block?(self.asset) == false {return}
        
        sender.isSelected = !sender.isSelected
        sender.bounceAnimation(0.3)
        
    }
    
    deinit
    {
    }
    
}
