//
//  UIImage.swift
//  OA
//
//  Created by X on 15/4/29.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{
    
    func scaledToSize(_ size:CGSize)->UIImage
    {
        var w:CGFloat=size.width
        var h:CGFloat=size.height
        
        w = w == 0 ? 1 : w
        h = h == 0 ? 1 : h
        
        let size:CGSize=CGSize(width: w, height: h)
        
        //UIGraphicsBeginImageContext(size);
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        //Determine whether the screen is retina
        let scale = UIScreen.main.scale
        if(scale >= 2.0){
            UIGraphicsBeginImageContextWithOptions(size, false, scale);
        }else{
            UIGraphicsBeginImageContext(size);
        }
        // 绘制改变大小的图片
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()!;
        
        // End the context
        UIGraphicsEndImageContext();
        
        // Return the new image.
        return newImage;

    }
    
    func data(_ zip:CGFloat)->Data?
    {
        return UIImageJPEGRepresentation(self, zip)
    }
    
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .up) {
            return self
        }
        var transform = CGAffineTransform.identity
        switch (self.imageOrientation) {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        default:
            break
        }
        switch (self.imageOrientation) {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                        bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                        space: self.cgImage!.colorSpace!,
                                        bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx!.concatenate(transform)
        
        
        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx!.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
            break
        default:
            ctx!.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
            break
        }
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx!.makeImage()
        return UIImage(cgImage: cgimg!)
    }
}
