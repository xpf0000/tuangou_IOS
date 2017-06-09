//
//  CityListPostionCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/9.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CityListPostionCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    var pcity = ""
    {
        didSet
        {
            name.text = pcity
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
