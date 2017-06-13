//
//  XTextView.swift
//  lejia
//
//  Created by X on 15/10/15.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XTextView: UITextView,UITextViewDelegate {

    var placeHolderView:UITextField?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addEndButton()
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
        placeHolderView = UITextField()
        placeHolderView?.font = UIFont.systemFont(ofSize: 14.0)
        placeHolderView?.placeholder = str
        placeHolderView?.isEnabled = false
        self.addSubview(placeHolderView!)
        
        placeHolderView?.frame = CGRect(x: 5, y: 8, width: 30, height: 20)
        placeHolderView?.sizeToFit()
        placeHolderView?.frame = CGRect(x: 5, y: 8, width: (placeHolderView?.frame.size.width)!, height: (placeHolderView?.frame.size.height)!)
        
    }
    
}
