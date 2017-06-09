//
//  XHeaderRefreshView.swift
//  refresh
//
//  Created by X on 16/1/15.
//  Copyright © 2016年 refresh. All rights reserved.
//

import UIKit

class XHeaderRefreshView: UIView {
    
    weak var scrollView:UIScrollView?
    var refrushTime:Date=Date()
    var height:CGFloat = 80.0
    var block:RefreshBlock?
    var state:XRefreshState = .normal
    var loaded = false
    
    var oldEdgeInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    let downIcon:UIImageView=UIImageView()
    let msgLabel:UILabel=UILabel()
    let activity:UIActivityIndicatorView=UIActivityIndicatorView()
    
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
            
            self.frame=CGRect(x: 0, y: -height, width: newSuperview!.frame.width, height: height)
            
        }
        else
        {
            self.superview?.removeObserver(self, forKeyPath: "contentSize")
            self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        }
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if superview != nil && !loaded
        {
            loaded = true
            
            if let c = scrollView?.contentInset
            {
                oldEdgeInsets = c
            }

        }
        else
        {
            
        }
        
        
    }
    
    override func removeFromSuperview() {
        
        super.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor=UIColor.clear
        
        if XRefreshHeaderProgressBlock != nil
        {
            return
        }
        
        if let path = Bundle.main.path(forResource: "down.png", ofType: nil)
        {
            downIcon.image=UIImage(contentsOfFile: path)
        }
        
        self.addSubview(downIcon)
        
        msgLabel.text="下拉可以刷新";
        msgLabel.textColor=UIColor(red: 51.0/255.0, green: 71.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        msgLabel.textAlignment=NSTextAlignment.center;
        msgLabel.font=UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(msgLabel)
        
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        activity.isHidden = true
        
        self.addSubview(activity)
        
        
        msgLabel.translatesAutoresizingMaskIntoConstraints=false
        activity.translatesAutoresizingMaskIntoConstraints=false
        downIcon.translatesAutoresizingMaskIntoConstraints=false
        
        let cx = NSLayoutConstraint(item: msgLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let cy = NSLayoutConstraint(item: msgLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        self.addConstraints([cx,cy])
        
        
        let cy1 = NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let tr = NSLayoutConstraint(item: activity, attribute: .trailing, relatedBy: .equal, toItem: msgLabel, attribute: .leading, multiplier: 1.0, constant: -20.0)
        
        self.addConstraints([cy1,tr])
        
        
        let cy2 = NSLayoutConstraint(item: downIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let tr1 = NSLayoutConstraint(item: downIcon, attribute: .trailing, relatedBy: .equal, toItem: msgLabel, attribute: .leading, multiplier: 1.0, constant: -20.0)
        
        let w = NSLayoutConstraint(item: downIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        let h = NSLayoutConstraint(item: downIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        
        self.addConstraints([cy2,tr1,w,h])
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if(self.scrollView == nil)
        {
            return
        }
        
        if(keyPath == "contentSize")
        {
            self.frame.size.width = self.scrollView!.frame.size.width
        }
        
        if(keyPath == "contentOffset")
        {
            if(self.state == .willRefreshing || !scrollView!.refreshEnable || self.isHidden)
            {
                return
            }
            
            let y:CGFloat = scrollView!.contentOffset.y
            
            // 如果是向上滚动到看不见头部控件，直接返回
            if (y >= 0){return}
            
            XRefreshHeaderProgressBlock?(self,Double(-y/height))
            
            if (scrollView!.isDragging)
            {
                if (self.state == .normal && y <= -height)
                {
                    self.setState(.pulling)
                }
                else if (self.state == .pulling && y > -height)
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
        XRefreshHeaderProgressBlock?(self,1.0)
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
    
    func setState(_ state:XRefreshState)
    {
        if self.state ==  state
        {
            return
        }
        
        let oldState = self.state
        
        switch state
        {
        case .normal:
            
            if(oldState == .refreshing)
            {
                // 保存刷新时间
                self.refrushTime = Date()
                self.downIcon.transform = CGAffineTransform.identity;
                
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    
                    self.activity.alpha=0.0
                    self.scrollView?.contentInset.top = self.oldEdgeInsets.top
                    
                    }, completion: { (finish) -> Void in
                        
                        self.activity.isHidden = true
                        self.activity.alpha=1.0
                        self.activity.stopAnimating()
                        self.state = state
                        
                        let delayInSeconds:Double=0.25
                        let popTime:DispatchTime=DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        
                        DispatchQueue.main.asyncAfter(deadline: popTime, execute: { () -> Void in
                            XRefreshHeaderEndBlock?(self)
                            self.state = .pulling
                            self.setState(.normal)
                            
                            if(self.scrollView?.footRefresh?.end != true)
                            {
                                self.scrollView?.footRefresh?.reSet()
                            }
                            
                            self.scrollView?.refreshEnable = true
                            
                        })
                })
                
            }
            else
            {
                self.state = state
                self.downIcon.isHidden = false
                self.activity.stopAnimating()
                self.activity.isHidden = true
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.downIcon.transform=CGAffineTransform(rotationAngle: CGFloat(M_PI)*CGFloat(2.0))
                    
                    }, completion: { (finish) -> Void in
                        
                })
            }
            
            
        case .pulling:
            self.state = state
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                self.downIcon.transform=CGAffineTransform(rotationAngle: CGFloat(M_PI)*CGFloat(1.0))
                
                }, completion: { (finish) -> Void in
                    
            })
            
        case .refreshing:
            scrollView?.refreshEnable = false
            self.state = .refreshing
            self.state = state
            
            self.downIcon.isHidden = true
            self.activity.isHidden = false
            self.activity.startAnimating()
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                self.scrollView?.contentInset.top=self.height+self.oldEdgeInsets.top
                self.scrollView?.setContentOffset(CGPoint(x: 0, y: -self.height), animated: false)
                
                }, completion: { (finish) -> Void in
                    
                    self.scrollView?.footRefresh?.end=false
                    XRefreshHeaderBeginBlock?(self)
                    self.block?()
                    
            })
            
        case .willRefreshing:
            ""
        default:
            ""
        }
        
        
        self.setStateText()
    }
    
    func setStateText()
    {
        switch self.state
        {
        case .normal:
            ""
            self.msgLabel.text = "下拉可以刷新"
            
        case .pulling:
            ""
            self.msgLabel.text = "松开马上刷新"
            
        case .refreshing:
            ""
            self.msgLabel.text = "正在玩命刷新"
            
        case .willRefreshing:
            ""
        default:
            ""
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if (self.state == .willRefreshing) {
            self.setState(.refreshing)
        }
    }
    
    
    deinit
    {
        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        self.scrollView = nil
        self.block = nil
    }
    
    
}

