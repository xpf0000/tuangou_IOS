//
//  XRefresh.swift
//  lejia
//
//  Created by X on 15/9/25.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

typealias RefreshBlock = ()->Void

typealias RefreshProgressBlock = (UIView,Double)->Void
typealias RefreshViewBlock = (UIView)->Void

//状态
enum XRefreshState : NSInteger{
    case normal
    case pulling
    case refreshing
    case willRefreshing
    case end
}

private var headerV: XHeaderRefreshView?
private var footerV: XFooterRefreshView?

private var RefreshHeaderViewKey : CChar?
private var RefreshFooterViewKey : CChar?
private var XRefreshEnableKey : CChar?

var XRefreshHeaderProgressBlock:RefreshProgressBlock?
var XRefreshHeaderBeginBlock:RefreshViewBlock?
var XRefreshHeaderEndBlock:RefreshViewBlock?

var XRefreshFooterProgressBlock:RefreshProgressBlock?
var XRefreshFooterBeginBlock:RefreshViewBlock?
var XRefreshFooterEndBlock:RefreshViewBlock?
var XRefreshFooterNoMoreBlock:RefreshViewBlock?

func XRefreshConfig(_ headerProgress:RefreshProgressBlock?,headerBegin:RefreshViewBlock?,headerEnd:RefreshViewBlock?,footerProgress:RefreshProgressBlock?,footerBegin:RefreshViewBlock?,footerEnd:RefreshViewBlock?,noMore:RefreshViewBlock?)
{
    XRefreshHeaderProgressBlock = headerProgress
    XRefreshHeaderBeginBlock = headerBegin
    XRefreshHeaderEndBlock = headerEnd
    
    XRefreshFooterProgressBlock = footerProgress
    XRefreshFooterBeginBlock = footerBegin
    XRefreshFooterEndBlock = footerEnd
    XRefreshFooterNoMoreBlock = noMore
}

extension UIScrollView
{
    var refreshEnable:Bool
    {
        get
        {
            let b = (objc_getAssociatedObject(self, &XRefreshEnableKey) as? Bool) ?? true
            return b
        }
        set(newValue) {
            self.willChangeValue(forKey: "XRefreshEnableKey")
            objc_setAssociatedObject(self, &XRefreshEnableKey, newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.didChangeValue(forKey: "XRefreshEnableKey")
            
        }

    }
    
    func hideHeadRefresh()
    {
        self.headRefresh?.hide()
    }
    
    func showHeadRefresh()
    {
        self.headRefresh?.show()
    }
    
    func hideFootRefresh()
    {
        self.footRefresh?.hide()
    }
    
    func showFootRefresh()
    {
        self.footRefresh?.show()
    }
    
    func setHeaderRefresh(_ block:@escaping RefreshBlock)
    {
        let headerRefreshView:XHeaderRefreshView=XHeaderRefreshView(frame: CGRect.zero)
        self.addSubview(headerRefreshView)
        self.headRefresh=headerRefreshView
        headerRefreshView.block = block
        
    }
    
    weak var headRefresh:XHeaderRefreshView?
        {
        get
        {
            return objc_getAssociatedObject(self, &RefreshHeaderViewKey) as? XHeaderRefreshView
        }
        set(newValue) {
            self.willChangeValue(forKey: "RefreshHeaderViewKey")
            objc_setAssociatedObject(self, &RefreshHeaderViewKey, newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            self.didChangeValue(forKey: "RefreshHeaderViewKey")
            
        }
    }
    
    weak var footRefresh:XFooterRefreshView?
        {
        get
        {
            return objc_getAssociatedObject(self, &RefreshFooterViewKey) as? XFooterRefreshView
        }
        set(newValue) {
            self.willChangeValue(forKey: "RefreshFooterViewKey")
            objc_setAssociatedObject(self, &RefreshFooterViewKey, newValue,
                                     .OBJC_ASSOCIATION_ASSIGN)
            self.didChangeValue(forKey: "RefreshFooterViewKey")
            
        }
    }
    
    func beginHeaderRefresh()
    {
        self.headRefresh?.beginRefresh()
    }
    
    func endHeaderRefresh()
    {
        self.headRefresh?.endRefresh()
    }
    
    func setFooterRefresh(_ block:@escaping RefreshBlock)
    {
        let footerRefreshView:XFooterRefreshView=XFooterRefreshView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
        self.addSubview(footerRefreshView)
        self.footRefresh=footerRefreshView
        footerRefreshView.block=block
    }
    
    func beginFooterRefresh()
    {
        self.footRefresh?.beginRefresh()
    }
    
    func endFooterRefresh()
    {
        self.footRefresh?.endRefresh()
    }
    
    func LoadedAll()
    {
        self.footRefresh?.end = true
        self.footRefresh?.setState(.end)
    }
    
}



