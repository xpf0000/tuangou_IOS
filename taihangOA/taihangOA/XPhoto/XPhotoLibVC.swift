//
//  ViewController.swift
//  XPhoto
//
//  Created by X on 16/9/14.
//  Copyright © 2016年 XPhoto. All rights reserved.
//   http://kayosite.com/ios-development-and-detail-of-photo-framework.html
//  http://www.hangge.com/blog/cache/detail_763.html

import UIKit
import AssetsLibrary
import Photos
import PhotosUI

//资源库管理类


class XPhotoLibVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let table = UITableView()
    var block:XPhotoResultBlock?
    static var maxNum = 9
    
    //保存照片集合
    //var assets = [ALAsset]()
    
    func do_dismiss()
    {
        self.dismiss(animated: true) { 
            self.block = nil
            XPhotoHandle.Share.clean()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "照片"
        
        let button=UIButton(type: UIButtonType.custom)
        button.frame=CGRect(x: 0, y: 0, width: 21, height: 21);
        button.setTitle("取消", for: UIControlState())
        
        if let color = self.navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
        {
            button.setTitleColor(color, for: UIControlState())
        }
        else
        {
            button.setTitleColor(UIColor.white, for: UIControlState())
        }
        
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.sizeToFit()
        button.isExclusiveTouch = true
        
        button.addTarget(self, action: #selector(do_dismiss), for: .touchUpInside)
        
        
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        // 获取当前应用对照片的访问授权状态
        let authorizationStatus = ALAssetsLibrary.authorizationStatus()
        // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
        if authorizationStatus == .restricted || authorizationStatus == .denied
        {
            let dic = Bundle.main.infoDictionary
            
            var appName = ""
            
            if let str = dic?["CFBundleDisplayName"] as? String
            {
                appName = str
            }
            else
            {
                if let str = dic?["CFBundleName"] as? String
                {
                    appName = str
                }

            }

            let msg = "请在设备的\"设置-隐私-照片\"选项中，允许\(appName)访问你的手机相册"
            
            let alert = UIAlertView(title: "提示", message: msg, delegate: nil, cancelButtonTitle: "确定")
            
            alert.show()
            
            return
        }
        
        XPhotoHandle.Share.handleFinish { 
            [weak self]()->Void in
            
            self?.table.reloadData()
        }

        self.automaticallyAdjustsScrollViewInsets = false
        
        table.frame = CGRect(x: 0, y: 0, width: SW, height: SH)
        
        let header = UIView()
        
        if UINavigationBar.appearance().isTranslucent
        {
            header.frame = CGRect(x: 0, y: 0, width: SW, height: 64)
        }
        else
        {
            header.frame = CGRect(x: 0, y: 0, width: SW, height: 0)
        }
        
        table.tableHeaderView = header
        
        table.delegate = self
        table.dataSource = self
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(table)
        
        if(XPhotoHandle.Share.assetGroups.count > 0)
        {
            let vc = XPhotoChooseVC()
            let model = XPhotoHandle.Share.assetGroups[0]
            vc.title = model.title
            vc.assets = XPhotoHandle.Share.assets[model.id]!
            vc.block = block
            
            self.navigationController?.pushViewController(vc, animated: false)
        }

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return XPhotoHandle.Share.assetGroups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        
        let model = XPhotoHandle.Share.assetGroups[indexPath.row]
        
        let image = UIImageView()
        image.frame = CGRect(x: 15, y: 0, width: 60.0, height: 60.0)
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        cell.contentView.addSubview(image)

        let label = UILabel()
        label.frame = CGRect(x: 85.0, y: 0, width: SW-85.0, height: 60.0)
        
        model.imageBlock { 
            [weak self](img)->Void in
            if self == nil {return}
            image.image = img
            
        }
        
        image.image = model.image
        label.text = model.title
        
        cell.contentView.addSubview(label)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = XPhotoChooseVC()
        let model = XPhotoHandle.Share.assetGroups[indexPath.row]
        vc.title = model.title
        vc.assets = XPhotoHandle.Share.assets[model.id]!
        vc.block = block
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        XPhotoHandle.Share.chooseArr.removeAll(keepingCapacity: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit
    {
    }


}

