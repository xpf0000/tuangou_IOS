//
//  XHttpHandle.swift
//  chengshi
//
//  Created by X on 15/11/20.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


typealias JsonBlock = (JSON?)->Void
typealias XHttpHandleBlock = ([AnyObject])->Void

class XHttpHandle: NSObject {
    
    var autoReload=true
    var pageSize=10
    var page=1
    var end=false
    var url:String=""
    var pageStr=""
    var replace:[String:String]?
    var modelClass:AnyClass!
    
    fileprivate var resultBlock:JsonBlock?
    fileprivate var beforeBlock:XHttpHandleBlock?
    
    func ResultBlock(_ b:@escaping JsonBlock)
    {
        resultBlock = b
    }
    
    func BeforeBlock(_ b:@escaping XHttpHandleBlock)
    {
        beforeBlock = b
    }
    
    fileprivate var afterBlock:XHttpHandleBlock?
    
    func AfterBlock(_ b:@escaping XHttpHandleBlock)
    {
        afterBlock = b
    }
    
    fileprivate var resetBlock:XHttpHandleBlock?
    
    func ResetBlock(_ b:@escaping XHttpHandleBlock)
    {
        afterBlock = b
    }
    
    lazy var listArr:[AnyObject] = []
    lazy var keys:[String]=[]
    
    weak var scrollView:UIScrollView?
    
    var running = false
    
    override init() {
        super.init()
    }
    
    func setHandle(_ scrollView:UIScrollView?, url:String,pageStr:String,keys:[String],model:AnyClass)
    {
        self.scrollView = scrollView
        self.url=url
        self.pageStr=pageStr
        self.keys=keys
        modelClass=model
    }
    
    func reSet()
    {
        resetBlock?(listArr)
        
        scrollView?.footRefresh?.end = false
        scrollView?.footRefresh?.state = .pulling
        scrollView?.footRefresh?.setState(.normal)
        
        self.page=1
        self.end=false
    }
    
    func handle()
    {
        if(self.end || self.running || self.url == "")
        {
            return
        }
        
        self.running = true
        
        let url=self.url.replacingOccurrences(of: pageStr, with: "\(page)")
        
        
        Alamofire.request(url, method: .get).validate().responseJSON { [weak self]response in
            
            if(self == nil){return}
            
            switch response.result {
                
            case .success(let value):
                
                let o = JSON(value)
                self?.resultBlock?(o)
                
                if(o != JSON.null)
                {
                    
                    var temp:Array<AnyObject> = []
                    
                    var items=o
                    
                    for key in self!.keys
                    {
                        items=items[key]
                    }
                    
                    let info = items.arrayValue
                    if(info.count > 0)
                    {
                        let elementModelType = self!.modelClass as! Reflect.Type
                        
                        for item in info
                        {
                            let elementModel = elementModelType.parse(json: item,replace: self!.replace)
                            
                            temp.append(elementModel)
                        }
                        
                        if(info.count < self!.pageSize)
                        {
                            self!.end = true
                        }
                    }
                    else
                    {
                        self!.end = true
                    }
                    
                    if(self!.page == 1)
                    {
                        self!.listArr.removeAll(keepingCapacity: false)
                    }
                    
                    self!.listArr += temp
                    
                    self?.beforeBlock?(self!.listArr)
                    
                    if(self!.autoReload)
                    {
                        if let table = self?.scrollView as? UITableView
                        {
                            table.reloadData()
                        }
                        
                        if let collection = self?.scrollView as? UICollectionView
                        {
                            collection.reloadData()
                        }
                        
                    }
                    
                    self?.afterBlock?(self!.listArr)
                    
                    self!.page += 1
                    
                    if(self!.end)
                    {
                        self!.scrollView?.LoadedAll()
                    }
                    
                    self!.scrollView?.endHeaderRefresh()
                    self!.scrollView?.endFooterRefresh()
                    self!.scrollView?.showFootRefresh()
                    
                }
                else
                {
                    self!.scrollView?.showFootRefresh()
                    self!.scrollView?.endHeaderRefresh()
                    self!.scrollView?.endFooterRefresh()
                }
                
                self?.running = false
                
              
                
            case .failure(let error):
                
                self!.scrollView?.showFootRefresh()
                self!.scrollView?.endHeaderRefresh()
                self!.scrollView?.endFooterRefresh()
                
                XMessage.show(error.localizedDescription)
                
                print(error)
                
                
            }
        }

        
        
    }
    
    deinit
    {
        replace?.removeAll(keepingCapacity: false)
        replace = nil
        keys.removeAll(keepingCapacity: false)
        listArr.removeAll(keepingCapacity: false)
        scrollView = nil
        beforeBlock = nil
        afterBlock = nil
    }
}
