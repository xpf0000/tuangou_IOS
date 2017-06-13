//
//  XFooterRefreshView.swift
//  refresh
//
//  Created by X on 16/1/15.
//  Copyright © 2016年 refresh. All rights reserved.
//

import UIKit


class XFooterRefreshView: UIView {
    
    weak var scrollView:UIScrollView?
    let msgLabel:UILabel=UILabel()
    let activity:UIActivityIndicatorView=UIActivityIndicatorView()
    var block:RefreshBlock?
    var state:XRefreshState = .normal
    var end=false
    var height:CGFloat = 60
    
    var oldEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    func hide()
    {
        self.isHidden = true
    }
    
    func show()
    {
        self.isHidden = false
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.scrollView = newSuperview as? UIScrollView
        
        if(newSuperview != nil)
        {
            newSuperview!.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            newSuperview!.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            newSuperview!.sendSubview(toBack: self)
            self.frame.origin.y = newSuperview!.frame.size.height;
            
        }
        else
        {
            self.superview?.removeObserver(self, forKeyPath: "contentSize")
            self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if superview != nil
        {
        
            if let c = scrollView?.contentInset
            {
                oldEdgeInsets = c
            }
            
        }
        
        
    }
    
    override func removeFromSuperview() {
        
        super.removeFromSuperview()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor=UIColor.clear
        
        if XRefreshFooterProgressBlock != nil
        {
            return
        }
        
        msgLabel.text="上拉加载更多"
        msgLabel.textColor=UIColor(red: 51.0/255.0, green: 71.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        msgLabel.textAlignment=NSTextAlignment.center
        msgLabel.font=UIFont.boldSystemFont(ofSize: 15)
        
        self.addSubview(msgLabel)
        
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        activity.alpha=0.0
        
        self.addSubview(activity)
        
        msgLabel.translatesAutoresizingMaskIntoConstraints=false
        activity.translatesAutoresizingMaskIntoConstraints=false
        
        
        let cx = NSLayoutConstraint(item: msgLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let cy = NSLayoutConstraint(item: msgLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        self.addConstraints([cx,cy])
        
        let cy1 = NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let tr = NSLayoutConstraint(item: activity, attribute: .trailing, relatedBy: .equal, toItem: msgLabel, attribute: .leading, multiplier: 1.0, constant: -15.0)
        
        self.addConstraints([cy1,tr])
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if(self.scrollView == nil)
        {
            return
        }
        
        if(keyPath == "contentSize")
        {
            if self.scrollView!.contentSize.height < self.scrollView!.frame.size.height
            {
                self.scrollView!.contentSize.height = self.scrollView!.frame.size.height
            }
            
            self.frame=CGRect(x: 0, y: scrollView!.contentSize.height, width: scrollView!.frame.size.width, height: height)
            
        }
        
        if(keyPath == "contentOffset")
        {
            
            if(self.state == .end || !scrollView!.refreshEnable || self.isHidden)
            {
                return
            }
            
            let y:CGFloat = scrollView!.contentOffset.y
            var sizeY:CGFloat = scrollView!.contentSize.height-scrollView!.frame.height
            sizeY = sizeY < 0 ? 0 : sizeY
            
            if y <= 0
            {
                return
            }
            
            XRefreshFooterProgressBlock?(self,Double((y-sizeY)/height))
            
            if (scrollView!.isDragging)
            {
                
                if (self.state == .normal && y >= sizeY+height)
                {
                    self.setState(.pulling)
                }
                else if (self.state == .pulling && y < sizeY+height)
                {
                    self.setState(.normal)
                }
            }
            else if(self.state == .pulling)
            {
                self.setState(.refreshing)
            }
        }
    }
    
    func beginRefresh()
    {
        XRefreshFooterProgressBlock?(self,1.0)
        if(self.window != nil)
        {
            self.setState(.refreshing)
        }
        else
        {
            self.state = .willRefreshing
            super.setNeedsDisplay()
        }
    }
    
    func endRefresh()
    {
        let delayInSeconds:Double=0.25
        let popTime:DispatchTime=DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: { () -> Void in
            
            self.setState(.normal)
            
        })
    }
    
    func reSet()
    {
        self.state = .normal
        self.activity.alpha=0.0
        self.activity.stopAnimating()
        self.scrollView!.contentInset.bottom = oldEdgeInsets.bottom
        self.setStateText()
    }
    
    func setState(_ state:XRefreshState)
    {
        if self.state ==  state || self.state == .end
        {
            return
        }
        
        switch state
        {
        case .normal:
            
            if(self.state == .refreshing)
            {
                
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    self.activity.alpha=0.0
                    self.scrollView!.contentInset.bottom = self.oldEdgeInsets.bottom
                    
                    }, completion: { (finish) -> Void in
                        
                        self.activity.stopAnimating()
                        
                })
                
                let delayInSeconds:Double=0.25
                let popTime:DispatchTime=DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                DispatchQueue.main.asyncAfter(deadline: popTime, execute: { () -> Void in
                    
                    XRefreshFooterEndBlock?(self)
                    
                    self.state = .pulling
                    self.setState(.normal)
                    
                    self.scrollView!.refreshEnable = true
                    
                })
                
            }
            else
            {
                self.activity.alpha=0.0
                self.activity.stopAnimating()
            }
            
            
        case .pulling:
            ""
            
        case .refreshing:
            
            scrollView!.refreshEnable = false
            
            self.activity.isHidden = false
            self.activity.alpha=1.0
            self.activity.startAnimating()
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                
                self.scrollView!.contentInset.bottom=self.height+self.oldEdgeInsets.bottom
                
                var y:CGFloat = self.scrollView!.contentSize.height-self.scrollView!.frame.height+self.height
                
                if y < 0 && y > -self.height
                {
                    y = self.height + y
                }
                else if y < -self.height
                {
                    y = self.height
                }
                
                self.scrollView?.setContentOffset(CGPoint(x: 0, y: y), animated: false)
                
                }, completion: { (finish) -> Void in
                    
                    XRefreshFooterBeginBlock?(self)
                    self.block?()
            })
            
        case .willRefreshing:
            break
        case .end:
            
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.scrollView!.contentInset.bottom=oldEdgeInsets.bottom
            XRefreshFooterNoMoreBlock?(self)
            
            scrollView!.refreshEnable = true
        }
        self.state=state
        
        self.setStateText()
    }
    
    func setStateText()
    {
        switch self.state
        {
        case .normal:
            
            self.msgLabel.text = "上拉加载更多"
            
        case .pulling:
            
            self.msgLabel.text = "松开进行加载"
            
        case .refreshing:
            
            self.msgLabel.text = "正在玩命加载"
            
        case .willRefreshing:
            ""
        case .end:
            self.msgLabel.text = "已无更多内容"
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if (self.state == .willRefreshing) {
            self.setState(.refreshing)
        }
    }
    
    
    deinit
    {
        self.superview?.removeObserver(self, forKeyPath: "contentSize")
        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        self.scrollView = nil
        self.block = nil
        self.removeFromSuperview()
        
    }
    
    
}

