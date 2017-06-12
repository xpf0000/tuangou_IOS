//
//  RenzhengVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class RenzhengVC: UITableViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var real_name: UITextField!
    
    @IBOutlet weak var pnum: UITextField!
    
    @IBOutlet weak var zbtn: UIButton!
    
    @IBOutlet weak var fbtn: UIButton!
    
    var renzhenginfo:RenzhengModel?
    {
        didSet
        {
            real_name.text = renzhenginfo?.real_name ?? ""
            pnum.text = renzhenginfo?.id_number ?? ""
            
            let u = URL.init(string: renzhenginfo?.id_url ?? "")
            let u1 = URL.init(string: renzhenginfo?.id_url_back ?? "")
            
            zbtn.kf.setImage(with: u, for: .normal)
            fbtn.kf.setImage(with: u1, for: .normal)
        
        }
    }
    
    lazy var imagePicker:UIImagePickerController = UIImagePickerController()
    
    var nowbtn:UIButton?
    var zdata:Data?
    var fdata:Data?
    
    @IBAction func take_photo(_ sender: UIButton) {
        
        nowbtn = sender
        
        let cameraSheet:UIActionSheet=UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        cameraSheet.addButton(withTitle: "从相册选择")
        cameraSheet.addButton(withTitle: "拍照")
        
        cameraSheet.actionSheetStyle = UIActionSheetStyle.blackTranslucent;
        cameraSheet.show(in: UIApplication.shared.keyWindow!)
        
        
        
    }
    
    
    @IBAction func do_submit(_ sender: Any) {
        
        if !real_name.checkNull() || !pnum.checkNull()
        {
            XMessage.show("请完善认证信息")
            return
        }
        
        if renzhenginfo == nil && (fdata == nil || zdata == nil)
        {
            XMessage.show("请选择身份证正反面照片")
            return
        }
        
        var map : [String:Any] = [:]
        map["uid"]=DataCache.Share.User.id
        map["name"] = real_name.text!.trim()
        map["ids"] = pnum.text!.trim()
        
       if zdata != nil
       {
            map["file"] = zdata
        }
        
        if fdata != nil
        {
            map["file1"] = fdata
        }
        
        Api.user_do_renzheng(data: map) {[weak self] (res) in
            
            XAlertView.show("提交成功,请等待审核", block: { [weak self] in

                self?.dismiss(animated: true, completion: nil)
                
            })
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
                let imgData = UIImageJPEGRepresentation(img,0.5)
                if nowbtn == zbtn
                {
                    zdata = imgData
                }
                else
                {
                    fdata = imgData
                }
                
               nowbtn?.setImage(img, for: .normal)
                
                picker.dismiss(animated:true, completion:nil)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()

        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        real_name.addEndButton()
        pnum.addEndButton()
        
        imagePicker.delegate=self
        imagePicker.allowsEditing = true
        imagePicker.modalTransitionStyle=UIModalTransitionStyle.coverVertical
        
        getData()
     
    }
    
    func getData()
    {
        Api.user_getRenzhenginfo(uid: DataCache.Share.User.id) { [weak self](m) in
            
            self?.renzhenginfo = m
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, 0, 0, 0)
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, SW, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, SW, 0, 0)
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        tableView.separatorInset=UIEdgeInsets.zero
        tableView.layoutMargins=UIEdgeInsets.zero
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
