//
//  XPhotoUtil.swift
//  XPhoto
//
//  Created by 徐鹏飞 on 16/9/16.
//  Copyright © 2016年 XPhoto. All rights reserved.
//

import UIKit
import AssetsLibrary

typealias XPhotoResultBlock = ([XPhotoAssetModel])->Void
typealias XPhotoChooseAssetBlock = (XPhotoAssetModel)->Bool
typealias XPhotoImageBlock = (UIImage?)->Void
typealias XPhotoFinishBlock = ()->Void
typealias XPhotoAllChooseBlock = (Bool)->Void

var XPhotoUseVersion7 = false



extension String{
    
    func fileExistsInBundle()->Bool
    {
        let filePath=Bundle.main.path(forResource: self, ofType:"")
        if(filePath == nil)
        {
            return false
        }
        
        let fileManager=FileManager.default
        if(fileManager.fileExists(atPath: filePath!))
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    func fileExistsInPath()->Bool
    {
        let fileManager=FileManager.default
        if(fileManager.fileExists(atPath: self))
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    var data:Data?
    {
        return self.data(using: String.Encoding.utf8)
    }
    

}



extension UIView
{
    
    func bounceAnimation(_ dur:TimeInterval)
    {
        let  animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = dur;
        
        animation.isRemovedOnCompletion = false;
        
        animation.fillMode = kCAFillModeForwards;
        
        var values : Array<AnyObject> = []
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.26, 1.26, 1.26)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //animation.delegate = delegate
        self.layer.add(animation, forKey: nil)
        
    }
    
    
    func bounceAnimation1(_ dur:TimeInterval)
    {
        let  animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = dur;
        
        animation.isRemovedOnCompletion = false;
        
        animation.fillMode = kCAFillModeForwards;
        
        var values : Array<AnyObject> = []
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.4, 0.4, 0.4)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.26, 1.26, 1.26)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 0.8)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //animation.delegate = delegate
        self.layer.add(animation, forKey: nil)
        
    }
    
}


