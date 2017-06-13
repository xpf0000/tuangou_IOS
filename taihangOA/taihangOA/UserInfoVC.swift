//
//  UserInfoVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class UserInfoVC: UITableViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var header: UIImageView!
    
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var idsnum: UITextField!
    
    
    @IBAction func do_submit(_ sender: Any) {
        
        if imgdata == nil {
            XMessage.show("请先选择头像")
            return
        }
        
        var map : [String:Any] = [:]
        map["uid"]=DataCache.Share.User.id
        map["file"] = imgdata
        
        Api.app_upload_avatar(data: map) { [weak self](res) in
            
        }
        
    }
    
    
    lazy var imagePicker:UIImagePickerController = UIImagePickerController()
    var imgdata:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "基本信息"
        self.addBackButton()
        
        imagePicker.delegate=self
        imagePicker.allowsEditing = true
        imagePicker.modalTransitionStyle=UIModalTransitionStyle.coverVertical
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        var icon = DataCache.Share.User.avatar
        if !icon.has("http://") && !icon.has("https://")
        {
            icon = "http://tg01.sssvip.net/" + icon
        }
        
        header.kf.setImage(with: icon.url())
        
        mobile.text = DataCache.Share.User.user_name
        name.text = DataCache.Share.User.real_name
        idsnum.text = DataCache.Share.User.id_number
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            let cameraSheet:UIActionSheet=UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            cameraSheet.addButton(withTitle: "从相册选择")
            cameraSheet.addButton(withTitle: "拍照")
            cameraSheet.actionSheetStyle = UIActionSheetStyle.blackTranslucent;
            cameraSheet.show(in: UIApplication.shared.keyWindow!)
        }
        
    }
    
    
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        print(buttonIndex)
        
        if(buttonIndex == 1)
        {
            imagePicker.sourceType=UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else if(buttonIndex == 2)
        {
            imagePicker.sourceType=UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print(info)
        
        let type:String = (info[UIImagePickerControllerMediaType]as!String)
        //当选择的类型是图片
        if type=="public.image"
        {
            if let img = info[UIImagePickerControllerEditedImage]as?UIImage
            {
                imgdata = UIImageJPEGRepresentation(img,0.5)
                
                header.image = img
                
                picker.dismiss(animated:true, completion:nil)
            }
            
        }
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

}
