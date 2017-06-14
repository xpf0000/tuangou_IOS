//
//  XPhotoDelChoose.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos


class XPhotoDelChoose: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,XZoomImageViewDelegate {
    
    var block:XPhotoResultBlock?
    var collection:UICollectionView!
    let color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
    let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SW, height: 64))
    
    let delBtn = UIButton.init(type: .custom)
    
    var assets:[XPhotoAssetModel] = []
    
    var imgArr:[IndexPath:UIImage] = [:]
    
    var indexPath:IndexPath!

    func onResult(b:@escaping XPhotoResultBlock)
    {
        block = b
    }
    
    func do_dismiss()
    {
        self.block?(assets)
        pop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.automaticallyAdjustsScrollViewInsets = false
        
        topView.backgroundColor = color
        
        let btn = UIButton()
        btn.frame = CGRect.init(x: 12, y: 23, width: 22, height: 22)
        btn.setImage("back@2x.png".image(), for: .normal)
        
        btn.addTarget(self, action: #selector(do_dismiss), for: .touchUpInside)
        
        topView.addSubview(btn)
        
        delBtn.frame = CGRect.init(x: (SW-28.0)/2.0, y: SH-35-28, width: 28, height: 28)
        delBtn.setImage("del_icon_w.png".image(), for: .normal)
        
        delBtn.addTarget(self, action: #selector(doDel), for: .touchUpInside)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = CGSize(width: SW, height: SH)
        
        collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: SW, height: SH), collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(collection)
        
        getRawImage(indexPath)
        collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        self.view.addSubview(topView)
        
        self.view.addSubview(delBtn)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        
        let asset = assets[indexPath.row]
        
        let imgView = XZoomImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: SW, height: SH)
        imgView.tapDelegate = self
        if let img = imgArr[indexPath]
        {
            imgView.image = img
        }
        else
        {
            imgView.image = asset.image
        }
        
        cell.contentView.addSubview(imgView)
        
        return cell
        
    }
    
    
    func XZoomImageViewTapClick() {
        
        topView.isHidden = !topView.isHidden
       
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentPage : Int = Int(floor((scrollView.contentOffset.x - SW/2)/SW))+1;
        
        indexPath = IndexPath(row: currentPage, section: 0)
        
        if  imgArr[indexPath] == nil
        {
            getRawImage(indexPath)
        }
        
    }
    
    
    
    func doDel()
    {
        
        if indexPath.row == assets.count - 1
        {
            imgArr.removeValue(forKey: indexPath)
        }
        else
        {

            for i in indexPath.row ..< assets.count - 1
            {
                let index = IndexPath.init(row: i + 1, section: 0)
                let key = IndexPath.init(row: i, section: 0)
                if let v =  imgArr[index]
                {
                    imgArr[key] = v
                }
                else
                {
                    imgArr.removeValue(forKey: key)
                }
                
            }
            
            let index = IndexPath.init(row: assets.count  - 1, section: 0)
            imgArr.removeValue(forKey: index)
            
        }
        
        assets.remove(at: indexPath.row)
        
        
        if(assets.count > 0)
        {
            let r = indexPath.row  - 1 < 0 ? 0 : indexPath.row  - 1
            indexPath = IndexPath.init(row: r, section: 0)
            
            if  imgArr[indexPath] == nil
            {
                getRawImage(indexPath)
            }
            
            collection.reloadData()
            collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        else
        {
            do_dismiss()
        }
        
    
    }
    
    
    func getRawImage(_ index:IndexPath)
    {
        
        
        let ass = assets[index.row].alasset
        
        if #available(iOS 8.0, *)
        {
            if let phasset = ass as? PHAsset
            {
                let opt = PHImageRequestOptions()
                opt.resizeMode = .fast
                PHImageManager.default().requestImage(for: phasset, targetSize: CGSize(width: SW*SC, height: SH*SC), contentMode: .aspectFill, options: opt, resultHandler: { [weak self](result, info) in
                    if self == nil {return}
                    if result != nil
                    {
                        if let cell = self?.collection.cellForItem(at: index)
                        {
                            let imgV = cell.contentView.subviews[0] as! XZoomImageView
                            imgV.image = result
                        }
                        
                        self?.imgArr[index] = result
                    }
                    
                    
                })
            }
        }
        else
        {
            if let asset = ass as? ALAsset
            {
                let  image = UIImage(cgImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
                if let cell = self.collection.cellForItem(at: index)
                {
                    let imgV = cell.contentView.subviews[0] as! XZoomImageView
                    imgV.image = image
                }
                self.imgArr[index] = image
            }
            
        }
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        
        if let nvBar = self.navigationController?.navigationBar
        {
            nvBar.isHidden = true
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        
        if let nvBar = self.navigationController?.navigationBar
        {
            nvBar.isHidden = false
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.imgArr.removeAll(keepingCapacity: false)
        
    }
    
    
    
}

