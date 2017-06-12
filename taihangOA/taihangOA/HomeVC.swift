//
//  ViewController.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Cartography
import SwiftyJSON
import Kingfisher

class HomeVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collect: UICollectionView!
    var  homeModel = HomeModel()
    let topBar = HomeTopBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(DataCache.Share.city.id == "")
        {
            let vc = "CityListVC".VC(name: "Main") as! CityListVC
            vc.first = true
            
            vc.onChoose {[weak self] in
                self?.topBar.setCityName()
                self?.getData()
            }
            
            let nv = XNavigationController.init(rootViewController: vc)

            self.show(nv, sender: nil)
        }
        
        self.view.backgroundColor = UIColor.white
        
        
        topBar.frame = CGRect(x: 0, y: 0, width: SW, height: 44.0)
        
        self.navigationController?.navigationBar.addSubview(topBar)
        
        initTabBar()
        
        collect.register("HomeClassCell".Nib(), forCellWithReuseIdentifier: "HomeClassCell")
        collect.register("HomeTopicCell".Nib(), forCellWithReuseIdentifier: "HomeTopicCell")
        collect.register("HomeDealCell".Nib(), forCellWithReuseIdentifier: "HomeDealCell")
        
        
        collect.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CollectFooter")
        
        collect.register("HomeCHeader".Nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeCHeader")

        collect.contentInset.top = 20
        collect.contentInset.bottom = 50
        
        collect.setHeaderRefresh {[weak self] in
            
            self?.getData()
            
        }
        
        if(DataCache.Share.city.id != "")
        {
            getData()
        }
         
    }
    
    func initTabBar()
    {
        let arr:Array<UITabBarItem> = (self.tabBarController?.tabBar.items)!
        let scale = Int(UIScreen.main.scale)

        for (i,item) in arr.enumerated()
        {
            item.image="tab_\(i)@\(scale)x.png".image()!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.selectedImage="tab_\(i)_1@\(scale)x.png".image()!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
            item.setTitleTextAttributes([NSForegroundColorAttributeName:APPBlueColor,NSFontAttributeName:UIFont.systemFont(ofSize: 13.0)], for: UIControlState.selected)
            
            item.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13.0)], for: UIControlState.normal)
            
        }
    }
    
    func getData()
    {
        let cid = DataCache.Share.city.id
        
        Api.app_index(city_id: cid, xpoint: "", ypoint: "") { [weak self](model) in
            
            self?.collect.endHeaderRefresh()
            
            self?.homeModel = model
            self?.collect.reloadData()
            
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0
        {
            return homeModel.indexs.count
        }
        else if(section == 1)
        {
            return homeModel.zt_html.count
        }
        else if(section == 2)
        {
            return homeModel.deal_list.count
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0
        {
            return CGSize(width: SW/5.0, height: SW/5.0+10)
        }
        else if(indexPath.section == 1)
        {
            return CGSize(width: SW/3.0, height: SW/3.0)
        }
        else if(indexPath.section == 2)
        {
            return CGSize(width: SW, height: 100)
        }
        
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.section == 0)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeClassCell", for: indexPath) as! HomeClassCell
            
            cell.model = homeModel.indexs[indexPath.row]
            
            return cell
        }
        else if(indexPath.section == 1)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTopicCell", for: indexPath) as! HomeTopicCell
            
            cell.model = homeModel.zt_html[indexPath.row]
            
            return cell
        }
        else if(indexPath.section == 2)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDealCell", for: indexPath) as! HomeDealCell
            
            cell.model = homeModel.deal_list[indexPath.row]
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDealCell", for: indexPath) as! HomeDealCell
        
        cell.model = homeModel.deal_list[indexPath.row]
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if(section < 2)
        {
            return CGSize(width: SW, height: 12)
        }
        
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if(section == 2)
        {
            return CGSize(width: SW, height: 44)
        }
        
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if(indexPath.section < 2)
        {
            let view = collect.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CollectFooter", for: indexPath)
            
            view.backgroundColor = "efefef".color()
            
            return view
        }
        else
        {
            let view = collect.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeCHeader", for: indexPath)
            
            return view
        }
        
        
    }
    
    func dodeinit()
    {
        
   
    }
    
    deinit
    {
        dodeinit()
        print("HomeVC deinit !!!!!!!!!!!!!!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TabIndex = 0
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //banner.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

