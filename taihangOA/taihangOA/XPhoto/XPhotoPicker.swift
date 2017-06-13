//
//  XPhotoPicker.swift
//  XPhoto
//
//  Created by 徐鹏飞 on 16/9/17.
//  Copyright © 2016年 XPhoto. All rights reserved.
//

import UIKit

class XPhotoPicker: UIView,UIActionSheetDelegate {
    
    fileprivate weak var pushVC:UIViewController!
    fileprivate var block:XPhotoResultBlock?
    
    var maxNum = 9
    {
        didSet
        {
            XPhotoLibVC.maxNum = maxNum
        }
    }
    
    var allowsEditing = false
    {
        didSet
        {
                
        }
    }
    
    override fileprivate init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(allowsEditing:Bool)
    {
        super.init(frame: CGRect.zero)
        
        self.allowsEditing = allowsEditing
        
    }
    
    func getPhoto(_ vc:UIViewController,result:@escaping XPhotoResultBlock)
    {
        XPhotoHandle.Share.handle()
        
        pushVC = vc
        block = result
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        let sheet=UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        
        sheet.addButton(withTitle: "拍照")
        sheet.addButton(withTitle: "从手机相册选择")
        
        sheet.actionSheetStyle = UIActionSheetStyle.blackTranslucent;
        sheet.show(in: UIApplication.shared.keyWindow!)

    }
    
    
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 0
        {
            self.clean()
        }
        
        if(buttonIndex == 1)
        {
            let c = XCamera()
            c.canEdit = allowsEditing
            c.CameraImage(pushVC, block: {[weak self] (img) in
                if self == nil {return}
                
                let model = XPhotoAssetModel()
                model.image=img
                
                self?.block?([model])

                self?.clean()
                
            })
            
            
        }
        else if(buttonIndex == 2)
        {
            if self.allowsEditing
            {
                let c = XCamera()
                c.canEdit = true
                c.imagePicker.sourceType=UIImagePickerControllerSourceType.photoLibrary
                c.CameraImage(pushVC, block: {[weak self] (img) in
                    if self == nil {return}
                    
                    let model = XPhotoAssetModel()
                    model.image=img
                    
                    self?.block?([model])
                    
                    self?.clean()
                    
                    })

            }
            else
            {
                let vc = XPhotoLibVC()
                vc.block = block
                let nv = UINavigationController(rootViewController: vc)
                
                pushVC.present(nv, animated: true, completion: {
                    
                })
                
                
            }
            
            
        }
        
        
        
    }
    
    func clean()
    {
        self.removeFromSuperview()
    }
    
    deinit
    {
    }

}
