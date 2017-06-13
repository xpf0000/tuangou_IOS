//
//  XCamera.swift
//  chengshi
//
//  Created by X on 15/11/26.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
//let SW = UIScreen.main.bounds.size.width
//let SH = UIScreen.main.bounds.size.height
let SC = UIScreen.main.scale

typealias XCameraBlock = (UIImage)->Void

class XCamera: UIView ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    lazy var imagePicker:UIImagePickerController = UIImagePickerController()
    weak var vc:UIViewController?
    var block:XCameraBlock?
    var canEdit = false
    {
        didSet
        {
             imagePicker.allowsEditing=canEdit
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imagePicker.delegate=self
        imagePicker.sourceType=UIImagePickerControllerSourceType.camera
        
        imagePicker.allowsEditing=false
        imagePicker.modalTransitionStyle=UIModalTransitionStyle.coverVertical
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func CameraImage()
    {

        self.vc?.view.addSubview(self)
        
        self.vc?.present(imagePicker, animated: true) { () -> Void in
            
            //XPhotoChoose.Share().removeFromSuperview()
        }
    }
    
    func  CameraImage(_ vc:UIViewController, block:@escaping XCameraBlock)
    {
        self.vc=vc
        self.block = block
        
        CameraImage()
    }
    
    func  CameraImage(_ vc:UIViewController,canEdit:Bool, block:@escaping XCameraBlock)
    {
        self.canEdit = canEdit
        CameraImage(vc, block: block)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        vc?.dismiss(animated: true, completion: { () -> Void in
            
            self.clean()
            
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        autoreleasepool { 
            
            var image = image
            
            let imageOrientation=image?.imageOrientation;
            
            if(imageOrientation != .up)
            {
                // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
                // 以下为调整图片角度的部分
                
                let size = CGSize(width: SW*SC, height: (image?.size.height)!/(image?.size.width)!*SW*SC)
                
                //print(size)
                
                // 打开图片编辑模式
                
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                
                // 修改图片长和宽
                
                image?.draw(in: CGRect(origin: CGPoint.zero, size: size))
                
                // 生成新图片
                
                image = UIGraphicsGetImageFromCurrentImageContext()
                
                // 关闭图片编辑模式
                
                UIGraphicsEndImageContext()
                
                // 压缩图片
                
                
                // 调整图片角度完毕
            }
            
            self.block?(image!)
            
            vc?.dismiss(animated: true, completion: { () -> Void in
                self.clean()
            })
        }
 
    }
    
    func clean()
    {
        self.vc = nil
        self.block = nil
        imagePicker.delegate = nil
        self.removeFromSuperview()
    }
    
    deinit
    {
    }


}
