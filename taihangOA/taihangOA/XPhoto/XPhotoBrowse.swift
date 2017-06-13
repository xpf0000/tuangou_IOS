//
//  XPhotoBrowse.swift
//  XPhoto
//
//  Created by 徐鹏飞 on 16/9/17.
//  Copyright © 2016年 XPhoto. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

class XPhotoBrowse: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,XZoomImageViewDelegate {

    var block:XPhotoResultBlock?
    var collection:UICollectionView!
    let tool = XPhotoToolbar()
    let color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
    
    let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SW, height: 64))
    
    var nowRow = 0
    {
        didSet
        {
            checkChoosed()
        }
    }
    
    var assets:[XPhotoAssetModel] = []
    
    var imgArr:[IndexPath:UIImage] = [:]
    
    var indexPath:IndexPath!
    {
        didSet
        {
            nowRow = indexPath.row
        }
    }
    
    func checkChoosed()
    {
        tool.all.isSelected = XPhotoHandle.Share.chooseArr.contains(assets[nowRow])
    }
    
    func do_dismiss()
    {
        self.dismiss(animated: true) {
            self.block = nil
            XPhotoHandle.Share.clean()
        }
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

        tool.singleChoose = true
        tool.frame = CGRect(x: 0, y: SH-50, width: SW, height: 50)
        tool.layer.masksToBounds = true
        tool.layer.shadowColor = UIColor.clear.cgColor
        tool.cancle.isHidden = true
        tool.isTranslucent = true
        tool.backgroundColor = color
        tool.setBackgroundImage(color.image(), forToolbarPosition: .top, barMetrics: .compact)
        self.view.addSubview(tool)
        
        tool.block({ [weak self,weak tool](all) in
            if self == nil || tool == nil {return}
            _ = self?.doChoose()
            }, cancle: { [weak self]()->Void in
                if self == nil {return}
        }) { [weak self]()->Void in
            if self == nil {return}
            self?.block?(XPhotoHandle.Share.chooseArr)
            self?.do_dismiss()
            
        }
        
        getRawImage(indexPath)
        collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        self.view.addSubview(topView)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let nvBar = self.navigationController?.navigationBar
        {
            nvBar.isHidden = !nvBar.isHidden
        }
        
        tool.isHidden = !tool.isHidden
        
    }
    
    func XZoomImageViewTapClick() {
    
       topView.isHidden = !topView.isHidden
        tool.isHidden = !tool.isHidden

    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentPage : Int = Int(floor((scrollView.contentOffset.x - SW/2)/SW))+1;
        
        nowRow = currentPage
        
        let index = IndexPath(row: currentPage, section: 0)
        
        if  imgArr[index] == nil
        {
           getRawImage(index)
        }

    }
    
    
    
    func doChoose()->Bool
    {
        
        let asset = assets[nowRow]
        
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
