//
//  XImageBrowse.swift
//  chengshi
//
//  Created by X on 15/11/28.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import AVFoundation

class XImageBrowse: UIView,UIScrollViewDelegate,zoomScrollDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //static let Share = XImageBrowse(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    
    var collection:UICollectionView!
    let clayout = UICollectionViewFlowLayout()
    
    lazy var imageArr:Array<UIImageView> = []
    var beginFrame:CGRect = CGRect.zero
    var index:Int=0
    var showIng:Bool=false
    
    let startBGC = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    let endBGC = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    let swidth = UIScreen.main.bounds.width
    let sheight = UIScreen.main.bounds.height
    
    convenience init(arr:[UIImageView])
    {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.imageArr = arr
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clayout.scrollDirection = .horizontal
        clayout.minimumLineSpacing = 0.0
        clayout.minimumInteritemSpacing = 0.0
        clayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        collection = UICollectionView(frame: frame, collectionViewLayout: clayout)
        collection.backgroundColor = UIColor.black
        collection.bounces = true
        collection.clipsToBounds = true
        collection.isPagingEnabled = true
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collection.alpha = 0.0
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = startBGC
        
        self.addSubview(collection)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        
        let i = indexPath.row
        let item = self.imageArr[i]
        
        let zoomScrollView:MRZoomScrollView = MRZoomScrollView(img: item)
        
        zoomScrollView.frame = CGRect(x: 0, y: 0, width: swidth, height: sheight)
        
        zoomScrollView.tag=70+i
        zoomScrollView.zoomDelegate=self
        cell.contentView.addSubview(zoomScrollView)
        
        return cell
    }
    
    
    func show(_ img:UIImageView)
    {
        let index = self.imageArr.index(of: img)
        let frame=img.superview?.convert(img.frame, to: UIApplication.shared.keyWindow)
        if index == nil || frame == nil {return}
        
        self.showIng = true
        self.index = index!
        
        self.beginFrame = frame!
        
        self.collection.reloadData()
        
        let indexPath = IndexPath(row: index!, section: 0)
        
        self.collection.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        
        self.show()
        
    }
    
    fileprivate func show()
    {
        
        let fromImage = imageArr[index]
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = beginFrame
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        self.addSubview(view)
        
        let toImage = UIImageView()
        toImage.image = fromImage.image
        view.addSubview(toImage)
        
        toImage.frame = trueFrame(fromImage)
        toImage.center = imgCenter(beginFrame, img: fromImage)
        toImage.contentMode = .scaleToFill
        
        var rect = CGRect.zero
        
        if fromImage.image != nil
        {
            rect = AVMakeRect(aspectRatio: fromImage.image!.size, insideRect: CGRect(x: 0, y: 0, width: self.swidth, height: self.sheight))
        }
        
        fromImage.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            view.frame = CGRect(x: 0, y: 0, width: self.swidth, height: self.sheight)
            
            toImage.frame = rect
            
            self.backgroundColor = self.endBGC
            
            }, completion: {
                
                (completion) in
                
                toImage.removeFromSuperview()
                view.removeFromSuperview()
                self.collection.alpha = 1.0
                fromImage.alpha = 1.0
                
        })
    }
    
    
    
    func hide()
    {
        index = Int(floor(self.collection.contentOffset.x / swidth))
        
        let temp=viewWithTag(70+index) as! MRZoomScrollView
        
        temp.fixImage()
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: swidth, height: sheight)
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        
        let fromImg = temp.imageView!
        
        
        
        let fromeFrame = fromImg.superview?.convert(fromImg.frame, to: UIApplication.shared.keyWindow)
        
        view.addSubview(fromImg)
        
        if fromeFrame != nil{
            
            fromImg.frame = fromeFrame!
        }
        
        self.collection.alpha = 0.0
        
        let toImg = imageArr[index]
        if toImg.image == nil
        {
            toImg.image = temp.imageView!.image
        }
        let toFrame = trueFrame(toImg)
        
        if toImg.contentMode == .redraw || toImg.contentMode == .scaleToFill
        {
            fromImg.contentMode = .scaleToFill
        }
        
        fromImg.clipsToBounds = toImg.clipsToBounds
        fromImg.layer.masksToBounds = toImg.layer.masksToBounds
        
        
        let toViewFrame = toImg.superview?.convert(toImg.frame, to: UIApplication.shared.keyWindow)
        
        if toViewFrame != nil && fromeFrame != nil
        {
            self.addSubview(view)
        }
        
        toImg.alpha=0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            if toViewFrame == nil || fromeFrame == nil
            {
                view.alpha=0.0
                toImg.alpha=1.0
            }
            else
            {
                view.frame = toViewFrame!
                fromImg.frame = toFrame
                fromImg.center = self.imgCenter(view.frame, img: toImg)
            }
            
            self.backgroundColor = self.startBGC
            
            }, completion: {
                
                (completion) in
                toImg.alpha=1.0
                self.imageArr.removeAll(keepingCapacity: false)
                self.collection.delegate = nil
                self.collection.dataSource = nil
                self.collection.removeFromSuperview()
                fromImg.removeFromSuperview()
                view.removeFromSuperview()
                self.removeFromSuperview()
                
                
        })
        
    }
    
    func imgCenter(_ frame:CGRect,img:UIImageView)->CGPoint
    {
        
        switch img.contentMode
        {
            
        case .top:
            return CGPoint(x: frame.width/2.0, y: img.image!.size.height/2.0)
            
        case .bottom:
            return CGPoint(x: frame.width/2.0, y: -(img.image!.size.height/2.0-frame.height))
            
        case .left:
            return CGPoint(x: img.image!.size.width/2.0, y: frame.height/2.0)
            
        case .right:
            return CGPoint(x: -(img.image!.size.width/2.0-frame.width), y: frame.height/2.0)
            
        case .topLeft:
            return CGPoint(x: img.image!.size.width/2.0, y: img.image!.size.height/2.0)
            
        case .topRight:
            return CGPoint(x: -(img.image!.size.width/2.0-frame.width), y: img.image!.size.height/2.0)
            
        case .bottomLeft:
            return CGPoint(x: img.image!.size.width/2.0, y: -(img.image!.size.height/2.0-frame.height))
            
        case .bottomRight:
            return CGPoint(x: -(img.image!.size.width/2.0-frame.width), y: -(img.image!.size.height/2.0-frame.height))
            
        default:
            return CGPoint(x: frame.width/2.0, y: frame.height/2.0)
        }
        
        
    }
    
    func trueFrame(_ img:UIImageView)->CGRect
    {
        if img.image == nil {return img.frame}
        
        switch img.contentMode
        {
        case .center,.top,.bottom,.left,.right,.topLeft,.topRight,.bottomLeft,.bottomRight:
            return CGRect(x: 0, y: 0, width: img.image!.size.width, height: img.image!.size.height)
            
        case .scaleAspectFit:

            let frame = img.frame
            let rect = AVMakeRect(aspectRatio: img.image!.size, insideRect: img.bounds)
            
            let x = frame.origin.x + rect.origin.x
            let y = frame.origin.y + rect.origin.y
            
            return CGRect(x: x, y: y , width: rect.size.width, height: rect.size.height)
            
        case .scaleAspectFill:
            let hw = img.frame.height / img.frame.width
            let hw1 = img.image!.size.height / img.image!.size.width
            var height:CGFloat = 0.0
            var width:CGFloat = 0.0
            if hw < hw1
            {
                width = img.frame.width
                height = hw1 * width
            }
            else
            {
                height = img.frame.height
                width = 1 / hw1 * height
            }
            
            return CGRect(x: 0, y: 0 , width: width, height: height)
            
            
        default:
            return img.frame
        }
        
    }
    
    
    
    func zoomTapClick() {
        
        self.hide()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        
    }
    
}
