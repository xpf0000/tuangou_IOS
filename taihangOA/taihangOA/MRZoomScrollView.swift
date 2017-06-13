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

@objc protocol zoomScrollDelegate:NSObjectProtocol{
    //回调方法
    @objc optional func zoomTapClick()
}

class MRZoomScrollView:UIScrollView,UIScrollViewDelegate
{
    var url:String?
    var imageView:UIImageView?
    var scroll:CGFloat?
    weak var zoomDelegate:zoomScrollDelegate?
    var canScroll:Bool?
    var wh:CGFloat=0.0
    var topOffset:CGFloat = 0.0
    var image:UIImage?

    let swidth=UIScreen.main.bounds.size.width
    let sheight=UIScreen.main.bounds.size.height
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func initSelf()
    {
        self.delegate=self
        self.frame = CGRect(x: 0, y: 0, width: swidth, height: sheight)
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 1.0;
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isUserInteractionEnabled=true;
        self.isScrollEnabled = false
        
        let singleTapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(MRZoomScrollView.singleTap))
        singleTapGestureRecognizer.numberOfTapsRequired=1
        self.addGestureRecognizer(singleTapGestureRecognizer)
        
        let doubleTapGesture=UITapGestureRecognizer(target: self, action: #selector(MRZoomScrollView.handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired=2
        self.addGestureRecognizer(doubleTapGesture)
        
        singleTapGestureRecognizer.require(toFail: doubleTapGesture)
    }
    
    init(img:AnyObject)
    {
        self.init()
        
        self.initSelf()
        scroll=0.0
        canScroll=false
        
        imageView=UIImageView(frame: CGRect.zero)
        imageView!.clipsToBounds = true
        imageView!.layer.masksToBounds = true
        imageView!.frame=CGRect(x: 0, y: 0, width: swidth,height: swidth*0.75)
        imageView!.center = CGPoint(x: swidth/2, y: sheight/2+(topOffset/2.0));
        imageView!.contentMode = .scaleAspectFit
        
        imageView?.addObserver(self, forKeyPath: "image", options: .new, context: nil)
        
        self.addSubview(imageView!)
        
        if let u = img as? String
        {
            imageView?.kf.setImage(with: u.url())
        }
        else if let u = img as? UIImage
        {
            imageView?.image = u
        }
        else if let u = img as? UIImageView
        {
            imageView?.kf.setImage(with: u.kf.webURL)
            imageView?.image = u.image
        }

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "image"
        {
            if self.imageView?.image != nil
            {
                self.fixImage()
                canScroll = true
            }
            else
            {
                canScroll = false
            }
        }
        
    }
    

    func singleTap()
    {
        self.zoomDelegate?.zoomTapClick!()
    }
    
    func handleDoubleTap(_ gesture:UIGestureRecognizer)
    {
        scroll=scroll==0.0 ? 2.0 : 0.0
        self.setZoomScale(scroll!, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if(canScroll==true)
        {
            return imageView
        }
        else
        {
            return nil
        }
    }
    
    func fixImage()
    {
        if wh == 0.0
        {
            wh = imageView!.image!.size.height / imageView!.image!.size.width
            
            let image = imageView!.image
            let rect = AVMakeRect(aspectRatio: imageView!.image!.size, insideRect: CGRect(x: 0, y: 0, width: self.swidth, height: self.sheight))
            
            imageView!.image = nil
            imageView!.frame=rect
            imageView!.center = CGPoint(x: swidth/2, y: sheight/2+(topOffset/2.0));
            imageView!.contentMode = .scaleToFill
            
            imageView!.image = image
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
        //self.fixImage()
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        if(wh<1)
        {
            imageView?.center.y = sheight/2+(topOffset/2.0)
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
        imageView?.removeObserver(self, forKeyPath: "image")
        imageView=nil
        url=nil
        self.delegate=nil
        self.zoomDelegate=nil
        self.scroll=nil
        self.canScroll=nil
    }
    
}
