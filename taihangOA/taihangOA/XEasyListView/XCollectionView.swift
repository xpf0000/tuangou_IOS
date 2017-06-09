//
//  XCollectionView.swift
//  XEasyListView
//
//  Created by X on 16/6/3.
//  Copyright © 2016年 XEasyListView. All rights reserved.
//

import UIKit

class XCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    let httpHandle:XHttpHandle=XHttpHandle()
    var postDict:[String:AnyObject]=[:]
    
    var CellIdentifier:String = ""
        {
        didSet
        {
            if NSClassFromString(ProjectName + "." + CellIdentifier) == nil
            {
                self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
            }
            else
            {
                self.register(CellIdentifier.Nib(), forCellWithReuseIdentifier: CellIdentifier)
            }
            
        }
    }
    
    var delegates:[UICollectionViewDelegate] = []
    
    let ViewLayout = UICollectionViewFlowLayout()
    
    var itemSize:CGSize!
        {
        didSet
        {
            ViewLayout.itemSize = itemSize
            reloadData()
        }
    }
    
    func Delegate(_ d:UICollectionViewDelegate)
    {
        if "\(d)" != "\(self)"
        {
            delegates.append(d)
        }
        
    }
    
    var dataSources:[UICollectionViewDataSource] = []
    
    func DataSource(_ d:UICollectionViewDataSource)
    {
        if "\(d)" != "\(self)"
        {
            dataSources.append(d)
        }
    }
    
    func initSelf()
    {
        backgroundColor = UIColor.white
        delegate = self
        dataSource = self
        
        ViewLayout.itemSize = CGSize(width: 1, height: 1)
        ViewLayout.minimumLineSpacing = 0.0
        ViewLayout.minimumInteritemSpacing = 0.0
        ViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.collectionViewLayout = ViewLayout
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
    }
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: UICollectionViewLayout())
        
        initSelf()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initSelf()
    }
    
    func setHandle(_ url:String,pageStr:String,keys:[String],model:AnyClass,CellIdentifier:String)
    {
        
        httpHandle.setHandle(self,url:url, pageStr: pageStr, keys: keys, model: model)
        
        self.CellIdentifier = CellIdentifier
        
    }
    
    func show()
    {
        self.setHeaderRefresh { [weak self] () -> Void in
            
            self?.httpHandle.reSet()
            
            self?.httpHandle.handle()
        }
        
        self.setFooterRefresh {[weak self] () -> Void in
            
            self?.httpHandle.handle()
        }
        
        self.httpHandle.handle()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return httpHandle.listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath)
        
        let model = httpHandle.listArr[indexPath.row]
        
        for (key,val) in self.postDict
        {
            cell.setValue(val, forKey: key)
        }
        
        cell.setValue(model, forKey: "model")
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegates.last?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
}
