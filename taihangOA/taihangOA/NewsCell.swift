//
//  NewsCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var ntitle: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    var model:NewsModel = NewsModel()
    {
        didSet
        {
            ntitle.text = model.title
            time.text = model.create_time
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setHighlighted(false, animated: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected)
        {
            deSelect()
            
            let vc = HtmlVC()
            vc.hidesBottomBarWhenPushed = true
            if let u = "http://tg01.sssvip.net/wap/index.php?ctl=news&act=app_newinfo&id=\(model.id)".url()
            {
                vc.url = u
            }
            
            vc.title = "详情"
            
            self.viewController?.show(vc, sender: nil)
  
        }
    }
    
}
