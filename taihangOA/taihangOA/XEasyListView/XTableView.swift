//
//  XTableView.swift
//  lejia
//
//  Created by X on 15/10/17.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import Foundation


class XTableView: UITableView ,UITableViewDataSource,UITableViewDelegate{
    
    var refreshWord = ""
        {
        didSet
        {
            NotificationCenter.default.addObserver(self, selector: #selector(noticedRefresh), name: NSNotification.Name(rawValue: refreshWord), object: nil)
        }
    }
    
    var CellIdentifier:String = ""
        {
        didSet
        {
            if NSClassFromString(ProjectName + "." + CellIdentifier) == nil
            {
                self.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
            }
            else
            {
                self.register(CellIdentifier.Nib(), forCellReuseIdentifier: CellIdentifier)
            }
        }
    }
    var cellHeight:CGFloat = 0.0
    var cellHDict:[IndexPath:CGFloat] = [:]
    var postDict:Dictionary<String,AnyObject>=[:]
    
    var publicCell:UITableViewCell?
    
    fileprivate weak var xdelegate:UITableViewDelegate?
    
    func Delegate(_ d:UITableViewDelegate)
    {
        xdelegate = d
    }
    
    fileprivate weak var xdataSource:UITableViewDataSource?
    
    func DataSource(_ d:UITableViewDataSource)
    {
        xdataSource = d
    }
    
    let httpHandle:XHttpHandle=XHttpHandle()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.initTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initTable()
    }
    
    func initTable()
    {
        delegate = self
        dataSource = self
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clear
        tableFooterView=view1
        tableHeaderView=view1
        
        httpHandle.scrollView = self
        
        httpHandle.ResetBlock { [weak self](o) in
            
            self?.cellHDict.removeAll(keepingCapacity: false)
        }
        
        setHeaderRefresh { [weak self] () -> Void in
            
            self?.httpHandle.reSet()
            
            self?.httpHandle.handle()
        }
        
        setFooterRefresh {[weak self] () -> Void in
            
            self?.httpHandle.handle()
        }
        
    }
    
    func noticedRefresh()
    {
        httpHandle.reSet()
        httpHandle.handle()
    }
    
    func refresh()
    {
        self.beginHeaderRefresh()
    }
    
    
    func setHandle(_ url:String,pageStr:String,keys:[String],model:AnyClass,CellIdentifier:String)
    {
        
        httpHandle.setHandle(self,url:url, pageStr: pageStr, keys: keys, model: model)
        
        self.CellIdentifier = CellIdentifier
        
    }
    
    func show()
    {
        self.httpHandle.handle()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        xdelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.httpHandle.listArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if publicCell == nil
        {
            publicCell = dequeueReusableCell(withIdentifier: CellIdentifier)
        }
        
        if let h = cellHDict[indexPath]
        {
            return h
        }
        else
        {
            if cellHeight == 0.0
            {
                let model = httpHandle.listArr[indexPath.row]
                publicCell?.setValue(model, forKey: "model")
                
                let size = publicCell?.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                
                if let h = size?.height
                {
                    cellHDict[indexPath] = h
                    
                    return h
                }
            }
        }
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        let model = self.httpHandle.listArr[indexPath.row]
        
        for (key,val) in self.postDict
        {
            cell.setValue(val, forKey: key)
        }
        
        cell.setValue(model, forKey: "model")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        
        if let b = xdataSource?.tableView?(tableView, canEditRowAt: indexPath)
        {
            return b
        }
        
        return false
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        xdataSource?.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        xdelegate?.tableView?(tableView, didSelectRowAt: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return xdelegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return xdelegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return xdataSource?.tableView?(tableView, titleForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return xdataSource?.tableView?(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return xdelegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        xdelegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if let h = xdelegate?.tableView?(tableView, heightForFooterInSection: section)
        {
            return h
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if let h = xdelegate?.tableView?(tableView, heightForHeaderInSection: section)
        {
            return h
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        xdelegate?.tableView?(tableView, didHighlightRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
        xdelegate?.tableView?(tableView, didEndEditingRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        xdelegate?.tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        if let h = xdataSource?.tableView?(tableView, canMoveRowAt: indexPath)
        {
            return h
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        
        if #available(iOS 9.0, *) {
            if let h = xdelegate?.tableView?(tableView, canFocusRowAt: indexPath)
            {
                return h
            }
        } else {
            // Fallback on earlier versions
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
        xdelegate?.tableView?(tableView, willBeginEditingRowAt: indexPath)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
        self.delegate = nil
        self.dataSource = nil
        xdelegate = nil
        xdataSource = nil
        cellHDict.removeAll(keepingCapacity: false)
        postDict.removeAll(keepingCapacity: false)
    }
    
}
