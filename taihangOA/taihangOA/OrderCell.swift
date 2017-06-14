//
//  OrderCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    @IBAction func btn_click(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "评价"
        {
            let vc = "CommentSubmitVC".VC(name: "Main") as! CommentSubmitVC
            vc.data_id = model.deal_id
            self.viewController?.show(vc, sender: nil)
            
        }
        else if sender.titleLabel?.text == "查看券码"
        {
            let vc = CouponListVC()
            vc.oid = model.id
            vc.name = model.sub_name
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.show(vc, sender: nil)
        }
        
        
    }
    
    var model:OrderItemModel = OrderItemModel()
    {
        didSet
        {
             let url = URL.init(string: model.deal_icon)
            img.kf.setImage(with: url)
            name.text = model.sub_name
            time.text = "下单时间：\(model.create_time)"
            price.text = "￥\(model.total_price)"
            
            if(model.pay_status != "2")
            {
                status.text = "未付款"
                btn.setTitle("付款", for: .normal)
                btn.isHidden = false
            }
            else
            {
                if(model.order_status == "1")
                {
                    
                    if(model.dp_id > 0)
                    {
                        status.text = "已点评"
                        btn.isHidden = true
                    }
                    else
                    {
                        status.text = "已消费"
                        btn.setTitle("评价", for: .normal)
                        btn.isHidden = false
                    }
                    
                }
                else
                {
                    status.text = "未使用"
                    btn.setTitle("查看券码", for: .normal)
                    btn.isHidden = false
                }
                
            }
            
            if(model.refund_status == 1)
            {
                status.text = "退款中"
                btn.isHidden = true
            }
            else if(model.refund_status == 2)
            {
                status.text = "已退款"
                btn.isHidden = true
            }
            else if(model.refund_status == 3)
            {
                status.text = "拒绝退款"
                btn.isHidden = true
            }
            
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setHighlighted(false, animated: false)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        btn.layer.cornerRadius = 4.0
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = "FFA500".color().cgColor
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected
        {
            deSelect()
            
        }
    }
    
}
