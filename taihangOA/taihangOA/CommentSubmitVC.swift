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
    
    var imgs:[Int:UIImageView] = [:]
    
    var imgarr : [UIImage] = []
    
    var harr:[CGFloat] = [70,12,100,12,100]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        star.num = 5
        content.placeHolder("菜品口味如何，服务周到吗，环境如何，（写够15字，才是好同志~）")
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        pics.ViewLayout.sectionInset.bottom = 16.0
        pics.ViewLayout.scrollDirection = .horizontal
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
            
            
            
            
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as! CommentPicCell
            
            var arr:[UIImageView] = []
            
            for i in 0..<imgarr.count
            {
                arr.append(imgs[i]!)
            }
            
            XImageBrowse(arr: arr).show(cell.img)
        }
     
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
