//
//  XPhotoToolbar.swift
//  XPhoto
//
//  Created by 徐鹏飞 on 16/9/16.
//  Copyright © 2016年 XPhoto. All rights reserved.
//

import UIKit


class XPhotoToolbar: UIToolbar {

    let all = UIButton(type: .custom)
    fileprivate let finishBtn = UIButton(type: .custom)
    let cancle = UIButton(type: .custom)
    fileprivate let num = UILabel()
    
    var singleChoose = false
    
    fileprivate var cancleBlock:XPhotoFinishBlock?
    fileprivate var finishBlock:XPhotoFinishBlock?
    fileprivate var allChooseBlock:XPhotoAllChooseBlock?
    
    func    block(_ allChoose:@escaping XPhotoAllChooseBlock,cancle:@escaping XPhotoFinishBlock,finish:@escaping XPhotoFinishBlock)
    {
        allChooseBlock=allChoose
        cancleBlock=cancle
        finishBlock=finish
    }
    
    
    var count = 0
    {
        didSet
        {
            finishBtn.isEnabled = count > 0
            num.isHidden = !(count > 0)
            num.text = "\(count)"
            if(!num.isHidden)
            {
                num.bounceAnimation1(0.4)
            }
            
        }
    }
    
    func initSelf()
    {
        
        all.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        all.setImage("Checkmark-0@2x.png".image(), for: UIControlState())
        all.setImage("Checkmark-1@2x.png".image(), for: .selected)
        all.imageView?.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        all.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        let item = UIBarButtonItem(customView: all)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        
        
        cancle.frame = CGRect(x: 0, y: 0, width: 50, height: 26)
        cancle.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        cancle.setTitle("取消", for: UIControlState())
        cancle.setTitleColor(UIColor.black, for: UIControlState())
        cancle.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: cancle)
        
        
        let orangeColor = UIColor(red: 253.0/255.0, green: 122.0/255.0, blue: 0.0, alpha: 1.0)
        let orangeColor1 = UIColor(red: 253.0/255.0, green: 122.0/255.0, blue: 0.0, alpha: 0.5)
        
        finishBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 26)
        
        
        num.frame = CGRect(x: 0, y: 3, width: 20, height: 20)
        num.textAlignment = .center
        num.text = "1"
        num.font = UIFont.systemFont(ofSize: 13.0)
        num.textColor = UIColor.white
        num.backgroundColor = orangeColor
        num.layer.masksToBounds=true
        num.layer.cornerRadius = 10.0
        
        finishBtn.addSubview(num)
        
        finishBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 22, 0.0, 0.0)
        
        finishBtn.setTitle("完成", for: UIControlState())
        finishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        finishBtn.setTitleColor(orangeColor1, for: .disabled)
        finishBtn.setTitleColor(orangeColor, for: UIControlState())
        
        finishBtn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        
        
        let item2 = UIBarButtonItem(customView: finishBtn)
        
        num.isHidden = true
        finishBtn.isEnabled = false
        
        setItems([item,space,item1,space,item2], animated: true)
        
        XPhotoHandle.Share.chooseChange { [weak self]()->Void in
            if self == nil {return}
            self?.count = XPhotoHandle.Share.chooseArr.count
        }
        
        count = XPhotoHandle.Share.chooseArr.count
        
    }
    
    func click(_ sender:UIButton)
    {
        if sender == all
        {
            if singleChoose && !sender.isSelected
            {
                if XPhotoHandle.Share.chooseArr.count == XPhotoLibVC.maxNum
                {
                    return
                }
            }
            
            sender.isSelected = !sender.isSelected
            sender.bounceAnimation(0.3)
            allChooseBlock?(sender.isSelected)
        }
        else if sender == cancle
        {
            cancleBlock?()
        }
        else
        {
            finishBlock?()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSelf()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
    }
    
    deinit
    {
    }
    
}
