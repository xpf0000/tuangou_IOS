//
//  CommentCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell,UICollectionViewDelegate {

    @IBOutlet weak var star: XStarView!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var pics: XCollectionView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var sub_name: UILabel!
    
    @IBOutlet weak var picH: NSLayoutConstraint!
    
    var imgs:[Int:UIImageView] = [:]
    
    var model:ItemBean = ItemBean()
    {
        didSet
        {
            star.num = model.point.numberValue.intValue
            time.text = model.create_time
            content.text = model.content
            icon.kf.setImage(with: model.icon.url())
            name.text = model.sub_name
            sub_name.text = model.sub_name
            
            if model.oimages.count == 0{
                picH.constant = 0.0
                pics.httpHandle.listArr.removeAll(keepingCapacity: false)
            }
            else
            {
                picH.constant = 90.0
                pics.httpHandle.listArr = model.oimages as [AnyObject]
            }
            
            pics.reloadData()
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pics.ViewLayout.sectionInset.bottom = 16.0
        pics.ViewLayout.scrollDirection = .horizontal
        pics.ViewLayout.itemSize = CGSize(width: 80.0, height: 80.0)
        pics.ViewLayout.minimumLineSpacing = 8.0
        pics.ViewLayout.minimumInteritemSpacing = 8.0
        pics.CellIdentifier = "CommentPicCell"
        
        pics.Delegate(self)
        
        pics.onGetCell { [weak self](indexPath, cell) in
            
            if let c = cell as? CommentPicCell
            {
                self?.imgs[indexPath.row] = c.img
            }
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! CommentPicCell
        
        var arr:[UIImageView] = []
        
        for i in 0..<imgs.count
        {
            arr.append(imgs[i]!)
        }
        
        XImageBrowse(arr: arr).show(cell.img)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
