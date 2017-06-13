//
//  MRZoomScrollView.swift
//  swiftTest
//
//  Created by X on 15/3/16.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc protocol XZoomImageViewDelegate:NSObjectProtocol{
    //回调方法
    @objc optional func XZoomImageViewTapClick()
}

class XZoomImageView:UIScrollView,UIScrollViewDelegate
{
    fileprivate var imageView:UIImageView?
    fileprivate var scroll:CGFloat?
    fileprivate var wh:CGFloat=0.0
    weak var tapDelegate:XZoomImageViewDelegate?
    
    var image:UIImage?
    {
        didSet
        {
            imageView?.image = image
            
            self.fixImage()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSelf()
        
    }
    
    func singleTap()
    {
        tapDelegate?.XZoomImageViewTapClick?()
    }
    
    func initSelf()
    {
        self.delegate=self
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 1.0;
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isUserInteractionEnabled=true;
        self.isScrollEnabled = false
        
        let singleTapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(singleTap))
        singleTapGestureRecognizer.numberOfTapsRequired=1
        self.addGestureRecognizer(singleTapGestureRecognizer)
        
        let doubleTapGesture=UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired=2
        self.addGestureRecognizer(doubleTapGesture)
        
        singleTapGestureRecognizer.require(toFail: doubleTapGesture)
        
        scroll=0.0
        
        imageView=UIImageView(frame: CGRect.zero)
        imageView!.clipsToBounds = true
        imageView!.layer.masksToBounds = true
        imageView!.frame=CGRect(x: 0, y: 0, width: SW,height: SW*0.75)
        imageView!.center = CGPoint(x: SW/2, y: SH/2);
        imageView!.contentMode = .scaleAspectFit
        
        self.addSubview(imageView!)

    }
    
    func handleDoubleTap(_ gesture:UIGestureRecognizer)
    {
        scroll=scroll==0.0 ? 2.0 : 0.0
        self.setZoomScale(scroll!, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func fixImage()
    {
        wh = imageView!.image!.size.height / imageView!.image!.size.width
        
        let image = imageView!.image
        let rect = AVMakeRect(aspectRatio: imageView!.image!.size, insideRect: CGRect(x: 0, y: 0, width: SW, height: SH))
        
        imageView!.image = nil
        imageView!.frame=rect
        imageView!.center = CGPoint(x: SW/2, y: SH/2);
        imageView!.contentMode = .scaleToFill
        
        imageView!.image = image
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        if(wh<1)
        {
            imageView?.center.y = SH/2
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        if scale > 1.0
        {
            self.isScrollEnabled = true
        }
        else
        {
            self.isScrollEnabled = false
        }

    }
    
    deinit
    {
        imageView=nil
        self.delegate=nil
        self.scroll=nil
    }
    
}
