//
//  CommentSubmitVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CommentSubmitVC: UITableViewController ,UICollectionViewDelegate{

    @IBOutlet weak var star: XStarView!
    
    @IBOutlet weak var content: XTextView!
    
    @IBOutlet weak var pics: XCollectionView!
    
    var data_id = ""
    
    var imgs:[Int:UIImageView] = [:]
    
    var imgarr : [XPhotoAssetModel] = []
    
    var harr:[CGFloat] = [70,12,100,12,100]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        let button=UIButton(type: UIButtonType.custom)
        button.frame=CGRect(x: 0, y: 0, width: 50, height: 21);
        button.setTitle("发布", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isExclusiveTouch = true
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        button.click {[weak self] (btn) in
            
            self?.do_submit()
            
        }

        
        star.num = 5
        content.placeHolder("菜品口味如何，服务周到吗，环境如何，（写够15字，才是好同志~）")
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        pics.ViewLayout.sectionInset.bottom = 16.0
        pics.ViewLayout.itemSize = CGSize(width: 80.0, height: 80.0)
        pics.ViewLayout.minimumLineSpacing = 8.0
        pics.ViewLayout.minimumInteritemSpacing = 8.0
        pics.CellIdentifier = "CommentPicCell"
        
        pics.contentInset.top = 10
        pics.contentInset.left = 10
        pics.contentInset.right = 10
        
        pics.Delegate(self)
        
        pics.onGetCell { [weak self](indexPath, cell) in
            
            if let c = cell as? CommentPicCell
            {
                self?.imgs[indexPath.row] = c.img
            }
            
        }
        
        pics.httpHandle.listArr = ["AddPhotoNormal.png" as AnyObject]
        
        pics.reloadData()
        
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.separatorInset=UIEdgeInsetsMake(0, SW, 0, 0)
        cell.layoutMargins=UIEdgeInsetsMake(0, SW, 0, 0)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        tableView.separatorInset=UIEdgeInsetsMake(0, SW, 0, 0)
        tableView.layoutMargins=UIEdgeInsetsMake(0, SW, 0, 0)
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return harr[indexPath.row]
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if indexPath.row == imgarr.count
        {
            
            
            let picker = XPhotoPicker(allowsEditing: false)
            picker.maxNum = 9-imgarr.count
            picker.getPhoto(self) { [weak self](res) in
                
                
                print(res)
                self?.photoChoosed(res)
                
                
            }

            
        }
        else
        {
            let vc = XPhotoDelChoose()
            vc.assets = imgarr
            vc.indexPath = indexPath
            
            vc.onResult(b: { [weak self](res) in
                
                self?.photoChoosed(res)
                
            })
            
            self.show(vc, sender: nil)
            
        }
     
    }
    
    
    func photoChoosed(_ res:[XPhotoAssetModel])
    {
        self.imgarr.removeAll(keepingCapacity: false)
        self.pics.httpHandle.listArr.removeAll(keepingCapacity: false)
        
        for item in res
        {
            self.imgarr.append(item)
            if let img = item.image
            {
                self.pics.httpHandle.listArr.append(img)
            }
            
        }
        
        if self.pics.httpHandle.listArr.count < 9
        {
            self.pics.httpHandle.listArr.append("AddPhotoNormal.png" as AnyObject)
        }
        
        self.pics.reloadData()
        resetheight()
        
    }
    
    func resetheight()
    {
            let num = ceil( Double(pics.httpHandle.listArr.count) / 4.0 )
            let h = (num * 88) + 16
        
            harr[4] = CGFloat(h)

            tableView.reloadData()
        
    }
    
    
    func do_submit()
    {
        self.view.endEdit()
        if star.num == 0
        {
            XMessage.show("请先给商家打分")
            return
        }
        
        XWaitingView.show()
        
        var map : [String:Any] = [:]
        map["uid"]=DataCache.Share.User.id
        map["data_id"] = data_id
        map["point"] = "\(star.num)"
        map["content"] = content.text!.trim()
        
       if(imgarr.count == 0)
       {
            submit(map: map)
            return
        }
        
        var i = 0
        let end = imgarr.count
        var k = 0
        for item in imgarr
        {
            
            item.getRawImage(block: { [weak self](img) in
                
                if let data = img?.data(0.1)
                {
                    map["xtest\(k).jpg"] = data
                    print("queue: \(k)")
                    
                    k += 1
                    if k == end
                    {
                        self?.submit(map: map)
                    }
                }
    
            })
            
            i += 1
   
        }
        
    }
    
    func submit(map : [String:Any])
    {
        
        print(map.count)
        
        Api.user_add_dp(data: map) {[weak self] (res) in
            
            XWaitingView.hide()
            
            if res
            {
                "OrderNeedRefresh".postNotice()
                
                XAlertView.show("评价提交成功", block: { [weak self] in
                    
                    self?.pop()
                    
                })
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
