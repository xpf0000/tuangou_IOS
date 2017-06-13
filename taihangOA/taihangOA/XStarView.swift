//
//  XStarView.swift
//  rexian V1.0
//
//  Created by X on 16/5/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class XStarView: UIView {

    lazy var arr:[UIButton] = []
    
    var num = 0
    {
        didSet
        {
            for item in self.subviews
            {
                if item is UIButton
                {
                    (item as! UIButton).isSelected = arr.index(of: (item as! UIButton))! < num
                }
            }
        }
    }
    
    var totalNum = 5
    
    func click(sender:UIButton)
    {
        if num == arr.index(of: sender)!+1
        {
            num = num - 1
        }
        else
        {
            num = arr.index(of: sender)!+1
        }
        
        
    }
    
    func setView()
    {
        self.removeAllSubViews()
        let w = frame.size.width / CGFloat(totalNum)
        
        for i in 0...4
        {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect.init(x: CGFloat(i)*w, y: 0, width: w, height: w)
            btn.setImage("list_star02.png".image(), for: .normal)
            btn.setImage("list_star01.png".image(), for: .selected)
            btn.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
            if i<num
            {
                btn.isSelected = true
            }
            
            self.addSubview(btn)
            
            arr.append(btn)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
    
}
