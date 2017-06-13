//
//  XPhotoChooseVC.swift
//  XPhoto
//
//  Created by X on 16/9/14.
//  Copyright © 2016年 XPhoto. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

class XPhotoChooseVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var block:XPhotoResultBlock?
    var collect:UICollectionView!
    let tool = XPhotoToolbar()
 
    var assets:[XPhotoAssetModel] = []

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"
        {
            if collect.contentSize.height > collect.frame.size.height
            {
                collect.contentOffset.y = collect.contentSize.height-collect.frame.size.height
            }
            
            collect.removeObserver(self, forKeyPath: "contentSize")
            
        }
    }
    
    func dismiss()
    {
        self.dismiss(animated: true) {
            self.block = nil
            XPhotoHandle.Share.clean()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        layout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0+50.0, 5.0)
        layout.itemSize = CGSize(width: (SW-25)/4.0, height: (SW-25)/4.0)
        
        collect = UICollectionView(frame: CGRect(x: 0, y: 0, width: SW, height: SH), collectionViewLayout: layout)
        
        collect.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        collect.backgroundColor = UIColor.white
        
        collect.delegate = self
        collect.dataSource = self
        
        collect.register(XPhotoChooseCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(collect)
        
        if UINavigationBar.appearance().isTranslucent
        {
            collect.frame = CGRect(x: 0, y: 0, width: SW, height: SH)
            tool.frame = CGRect(x: 0, y: SH-50, width: SW, height: 50)
        }
        else
        {
            collect.frame = CGRect(x: 0, y: 0, width: SW, height: SH-64)
            tool.frame = CGRect(x: 0, y: SH-64-50, width: SW, height: 50)
        }
        
        
        self.view.addSubview(tool)
        
        tool.block({ [weak self,weak tool](all) in
            if tool == nil {return}
            self?.doChooseAll(all)
            }, cancle: { [weak self]()->Void in
                if self == nil {return}
                self?.dismiss()
            }) { [weak self]()->Void in
                if self == nil {return}
                self?.block?(XPhotoHandle.Share.chooseArr)
                self?.dismiss()
                
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:XPhotoChooseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! XPhotoChooseCell
        
        let asset = assets[indexPath.row]
        cell.asset = asset

        cell.choose.isSelected = XPhotoHandle.Share.chooseArr.contains(asset )
        
        cell.doChoose {[weak self] (asset) ->Bool in
            if self == nil {return false}
            return self!.doChoose(asset)
        }
        
        return cell
        
    }
    
    func doChoose(_ asset:XPhotoAssetModel)->Bool
    {
    
        if let index = XPhotoHandle.Share.chooseArr.index(of: asset)
        {
            XPhotoHandle.Share.chooseArr.remove(at: index)
        }
        else
        {
            if XPhotoHandle.Share.chooseArr.count == XPhotoLibVC.maxNum{return false}
            XPhotoHandle.Share.chooseArr.append(asset)
        }
        
        //tool.count = XPhotoHandle.Share.chooseArr.count
        
        return true
        
    }
    
    func doChooseAll(_ all:Bool)
    {
        if all
        {
            let r = XPhotoLibVC.maxNum - XPhotoHandle.Share.chooseArr.count
            var c = 0
            for asset in assets.reversed()
            {
                if c == r {break}
                
                if !XPhotoHandle.Share.chooseArr.contains(asset )
                {
                    XPhotoHandle.Share.chooseArr.append(asset )
                    
                    for item in collect.visibleCells
                    {
                        if let cell = item as? XPhotoChooseCell
                        {
                            if cell.asset == asset 
                            {
                                cell.choose.isSelected = true
                                cell.choose.bounceAnimation(0.3)
                            }
                        }
                    }
                    
                    c += 1
                    
                }
                
            }

            //tool.count = XPhotoHandle.Share.chooseArr.count
        }
        else
        {
            XPhotoHandle.Share.chooseArr.removeAll(keepingCapacity: false)
            
            for item in collect.visibleCells
            {
                if let cell = item as? XPhotoChooseCell
                {
                    if cell.choose.isSelected
                    {
                        cell.choose.isSelected = false
                        cell.choose.bounceAnimation(0.3)
                    }
                }
            }
            
            //tool.count = 0
        }
    }
    
    fileprivate lazy var  tempChooseArr:[XPhotoAssetModel]  = []
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        tempChooseArr = XPhotoHandle.Share.chooseArr

        let vc = XPhotoBrowse()
        vc.assets = assets
        vc.indexPath = indexPath
        vc.block = block
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let b = tempChooseArr.count == XPhotoHandle.Share.chooseArr.count
        
        var b1 = true
        
        for item in XPhotoHandle.Share.chooseArr {
            if !tempChooseArr.contains(item)
            {
                b1 = false
            }
        }
        
        if !b || !b1
        {
            collect.reloadData()
        }
        
        tempChooseArr.removeAll(keepingCapacity: false)
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    deinit
    {
        assets.removeAll(keepingCapacity: false)
    }
    
    
    
    
    

}
