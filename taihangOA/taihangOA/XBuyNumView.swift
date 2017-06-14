//
//  XBuyNumView.swift
//  lejia
//
//  Created by X on 15/9/30.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

class XBuyNumView: UIView,UITextFieldDelegate {
    
    @IBOutlet var lineWidth: NSLayoutConstraint!
    
    var xframe:CGRect = CGRect.zero
    var num:Int=1
    {
        didSet
        {
            if oldValue != num
            {
                block?(num)
            }
        }
    }
    
    var block:XHorizontalMenuBlock?
    
    func onNumChange(b:@escaping XHorizontalMenuBlock)
    {
        self.block = b
    }
    
    var max:Int=0
    var min:Int=1
    {
        didSet
        {
            text.text = "\(min)"
            num = min
        }
    }

    override func layoutSubviews() {
        
        if(xframe != CGRect.zero)
        {
            self.frame = xframe
        }
        
        super.layoutSubviews()
        
        
    }
    
    
    @IBAction func clipClick(_ sender: AnyObject) {
        
        num = Int(text.text!)!
        if(num == min)
        {
            return
        }
        
        num -= 1
        text.text = "\(num)"
        
    }
    
    @IBAction func addClick(_ sender: AnyObject) {
        
        num = Int(text.text!)!
        if(num == max)
        {
            return
        }
        num += 1
        text.text = "\(num)"
    }
    
    @IBOutlet var text: UITextField!

    
    func initSelf()
    {
        let containerView:UIView=("XBuyNumView".Nib().instantiate(withOwner: self, options: nil))[0] as! UIView
        
        let newFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initSelf()
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineWidth.constant = 0.4
        self.layer.borderWidth = 0.4
        self.layer.borderColor = "#646464".color().cgColor
        self.layer.cornerRadius = 2.0
        
        self.text.addEndButton()
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        var txt=textField.text!
        txt=(txt as NSString).replacingCharacters(in: range, with: string)
        
        if(txt == "" || txt == "0" || txt.numberValue.intValue < min)
        {
            text.text = "\(min)"
            num = min
            return false
        }
        
        num = txt.numberValue.intValue
        
        return true
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        num = Int(text.text!)!
        
        if(num>max && max > 0)
        {
            XAlertView.show("超出最大范围", block: nil)
            num=max
            self.text.text = "\(num)"
        }
        
    }
    
    
    
    
    
    deinit
    {
        
    }

}
