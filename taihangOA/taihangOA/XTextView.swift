//
//  XTextView.swift
//  lejia
//
//  Created by X on 15/10/15.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XTextView: UITextView,UITextViewDelegate {

    var placeHolderView:UILabel?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addEndButton()
        
        initself()
        
    }
    
    func initself()
    {
        placeHolderView = UILabel()
        placeHolderView?.font = UIFont.systemFont(ofSize: 14.0)
        placeHolderView?.isEnabled = false
        placeHolderView?.numberOfLines = 0
        self.addSubview(placeHolderView!)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        placeHolderView?.preferredMaxLayoutWidth = self.frame.width - 10
    
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        
        if(textView.text.length() > 0)
        {
            self.placeHolderView?.isHidden = true
        }
        else
        {
            self.placeHolderView?.isHidden = false
        }
    }
    
    func placeHolder(_ str:String)
    {
        self.delegate = self
        
        placeHolderView?.text = str
        
        placeHolderView?.frame = CGRect(x: 5, y: 8, width: self.frame.size.width-10, height: 1)
        placeHolderView?.sizeToFit()
        placeHolderView?.frame = CGRect(x: 5, y: 8, width: (placeHolderView?.frame.size.width)!, height: (placeHolderView?.frame.size.height)!)
        
    }
    
}
