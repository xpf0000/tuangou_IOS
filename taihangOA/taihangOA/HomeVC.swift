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
        
        topBar.home = self
         
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            let bean = homeModel.indexs[indexPath.row]
            
            if bean.ctl == "url"
            {
                let vc = HtmlVC()
                vc.hidesBottomBarWhenPushed = true
                vc.url = bean.data.url.url()
                vc.title = bean.name
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "stores"
            {
                let vc = "StoresListVC".VC(name: "Main")  as! StoresListVC
                vc.cate_id = bean.data.cate_id
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "tuan"
            {
                let vc = "NearbyVC".VC(name: "Main")  as! NearbyVC
                vc.hidesBottomBarWhenPushed = true
                vc.cate_id = bean.data.cate_id
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "notices"
            {
                let vc = NoticesListVC()
                vc.hidesBottomBarWhenPushed = true
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "notice"
            {
                
                let vc = HtmlVC()
                vc.hidesBottomBarWhenPushed = true
                if let u = "http://tg01.sssvip.net/wap/index.php?ctl=notice&act=app_index&data_id=\(bean.data.data_id)".url()
                {
                    vc.url = u
                }
                
                vc.title = "详情"
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "deal"
            {
                
                let vc = HtmlVC()
                vc.hidesBottomBarWhenPushed = true
                
                let url = "http://tg01.sssvip.net/wap/index.php?ctl=deal&act=app_index&data_id="+bean.data.data_id+"&city_id="+DataCache.Share.city.id
                
                if let u = url.url()
                {
                    vc.url = u
                }
                
                vc.hideNavBar = true
                vc.tuanModel = TuanModel()
                vc.tuanModel.id = bean.data.data_id

                self.show(vc, sender: nil)

                
            }
            else if bean.ctl == "store"
            {
                
                let vc = HtmlVC()
                vc.hidesBottomBarWhenPushed = true
                
                let url = "http://tg01.sssvip.net/wap/index.php?ctl=store&act=app_index&data_id="+bean.data.data_id
                
                if let u = url.url()
                {
                    vc.url = u
                }
                
                vc.hideNavBar = true
                self.show(vc, sender: nil)
                
            }
            
            
        }
        else if indexPath.section == 1
        {
            
            let bean = homeModel.zt_html[indexPath.row]
            
            if bean.ctl == "url"
            {
                let vc = HtmlVC()
                vc.hidesBottomBarWhenPushed = true
                vc.url = bean.data.url.url()
                vc.title = bean.name
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "stores"
            {
                let vc = "StoresListVC".VC(name: "Main")  as! StoresListVC
                vc.cate_id = bean.data.cate_id
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "tuan"
            {
                let vc = "NearbyVC".VC(name: "Main")  as! NearbyVC
                vc.hidesBottomBarWhenPushed = true
                vc.cate_id = bean.data.cate_id
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "notices"
            {
                let vc = NoticesListVC()
                vc.hidesBottomBarWhenPushed = true
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "notice"
            {
                
                let vc = HtmlVC()
                vc.hidesBottomBarWhenPushed = true
                if let u = "http://tg01.sssvip.net/wap/index.php?ctl=notice&act=app_index&data_id=\(bean.data.data_id)".url()
                {
                    vc.url = u
                }
                
                vc.title = "详情"
                
                self.show(vc, sender: nil)
                
            }
            else if bean.ctl == "deal"
            {
                
                let vc = HtmlVC()
                vc.hidesBottomBarWhenPushed = true
                
                let url = "http://tg01.sssvip.net/wap/index.php?ctl=deal&act=app_index&data_id="+bean.data.data_id+"&city_id="+DataCache.Share.city.id
                
                if let u = url.url()
                {
                    vc.url = u
                }
                
                vc.hideNavBar = true
                vc.tuanModel = TuanModel()
                vc.tuanModel.id = bean.data.data_id
                
                self.show(vc, sender: nil)
                
                
            }
            else if bean.ctl == "store"
            {
                
                let vc = HtmlVC()
                vc.hidesBottomBarWhenPushed = true
                
                let url = "http://tg01.sssvip.net/wap/index.php?ctl=store&act=app_index&data_id="+bean.data.data_id
                
                if let u = url.url()
                {
                    vc.url = u
                }
                
                vc.hideNavBar = true
                self.show(vc, sender: nil)
                
            }
            
        }
        else
        {
            let model = homeModel.deal_list[indexPath.row]
            
            let vc = HtmlVC()
            vc.hidesBottomBarWhenPushed = true
            
            let url = "http://tg01.sssvip.net/wap/index.php?ctl=deal&act=app_index&data_id="+model.id+"&city_id="+DataCache.Share.city.id
            
            if let u = url.url()
            {
                vc.url = u
            }
            
            vc.hideNavBar = true
            vc.tuanModel = TuanModel()
            vc.tuanModel.id = model.id
            vc.tuanModel.sub_name = model.sub_name
            
            vc.title = "详情"
            
            self.show(vc, sender: nil)
        
            
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
        self.navigationController?.navigationBar.addSubview(topBar)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        topBar.removeFromSuperview()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

