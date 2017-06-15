//
//  HomeTopBar.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/8.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class HomeTopBar: UIView {

    
    @IBAction func to_scan(_ sender: Any) {
    
        let  scanner = ScannerViewController()
        self.viewController?.show(scanner, sender: nil)
    
    }
    
    weak var home:HomeVC?
    
    @IBAction func to_search(_ sender: Any) {
        
        let vc:ShopSearchVC = ShopSearchVC()
        let nv=XNavigationController(rootViewController: vc)
        
        self.viewController?.show(nv, sender: nil)
    
    }
    
    @IBOutlet weak var city: UIButton!
    
    @IBAction func to_city(_ sender: Any) {
        
        let vc = "CityListVC".VC(name: "Main") as! CityListVC
        let nv = XNavigationController.init(rootViewController: vc)
        
        vc.onChoose {[weak self] in
            
            self?.setCityName()
            self?.home?.getData()
            
        }
        
        self.viewController?.show(nv, sender: nil)
        
    }
    
    func setCityName()
    {
        city.setTitle(DataCache.Share.city.name, for: .normal)
    }
    
    func initSelf()
    {
        let containerView:UIView=("HomeTopBar".Nib().instantiate(withOwner: self, options: nil))[0] as! UIView
        let newFrame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        setCityName()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
        
    }
    

}
