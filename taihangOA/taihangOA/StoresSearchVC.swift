//
//  StoresSearchVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class StoresSearchVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate
{
    var url = ""
    var searchTxt = ""
    {
        didSet
        {
            if searchTxt == ""
            {
                httphandle.listArr.removeAll(keepingCapacity: false)
                table.reloadData()
                table.hideFootRefresh()
            }
            else
            {
                var url = Api.BaseUrl+"?ctl=stores&act=app_index&r_type=1&isapp=true"
                url += "&page=[page]"
                url += "&city_id="+DataCache.Share.city.id
                url += "&keyword="+searchTxt
                url += "&xpoint=\(XPosition.Share.postion.longitude)"
                url += "&ypoint=\(XPosition.Share.postion.latitude)"
                
                url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                table.footRefresh?.end = false
                table.footRefresh?.state = .pulling
                table.footRefresh?.setState(.normal)
                httphandle.running = false
                httphandle.url = url
                httphandle.reSet()
                httphandle.handle()
                
            }
        }
    }
    
    var searchbar:UISearchBar = UISearchBar()
    
    var table = UITableView()
    
    let httphandle = XHttpHandle()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = UIColor.white
        
        searchbar.layer.masksToBounds = true
        searchbar.clipsToBounds = true
        //searchbar.addEndButton()
        searchbar.placeholder = "请输入搜索关键词"
        searchbar.delegate = self
        
        searchbar.frame=CGRect.init(x: 8, y: 0, width: SW-16, height: 44)
        
        searchbar.subviews[0].subviews[0].removeFromSuperview()
        searchbar.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.addSubview(searchbar)
        
        searchbar.becomeFirstResponder()
        
        table.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH-64)
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clear
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        
        table.delegate = self
        table.dataSource = self
        
        table.register("StoresCell".Nib(), forCellReuseIdentifier: "StoresCell")
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(table)
        
        table.setFooterRefresh {[weak self]()->Void in
            
            self?.httphandle.handle()
        }
        
        
        table.hideFootRefresh()
        
        httphandle.pageStr = "[page]"
        httphandle.scrollView=table
        httphandle.keys=["data","item"]
        httphandle.modelClass=StoresModel.self
        
    }
    
    
    //MARK:-searchBar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchbar.showsScopeBar = true;
        searchbar.setShowsCancelButton(true, animated: true)
        
        let arr=searchbar.subviews[0].subviews
        
        for view in arr
        {
            if(view is UIButton)
            {
                (view as! UIButton).isEnabled=true
                (view as! UIButton).setTitle("取消", for: .normal)
                (view as! UIButton).setTitleColor(UIColor.white, for: .normal)
                break
            }
        }
        
        return true
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
        self.view.endEditing(true)
        
        self.pop()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchTxt = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
        
        DataCache.Share.StoresSearchKey.add(str: searchBar.text!)
        
    }
    

    //MARK:-table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchTxt == ""
        {
            return DataCache.Share.StoresSearchKey.keyArr.count+1
        }
        else
        {
            return httphandle.listArr.count
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if searchTxt == ""
        {
            return 44.0
        }
        else
        {
            return 100.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if searchTxt == ""
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.contentView.removeAllSubViews()
            
            if row < DataCache.Share.StoresSearchKey.keyArr.count
            {
                cell.textLabel?.textAlignment = .left
                cell.textLabel?.text = DataCache.Share.StoresSearchKey.keyArr[row]
            }
            else
            {
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "清除搜索记录"
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoresCell", for: indexPath) as! StoresCell
            
            cell.model = httphandle.listArr[row] as! StoresModel
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchTxt == ""
        {
            if row == DataCache.Share.StoresSearchKey.keyArr.count
            {
                DataCache.Share.StoresSearchKey.clean()
                table.reloadData()
            }
            else
            {
                searchbar.text = DataCache.Share.StoresSearchKey.keyArr[row]
                searchTxt = searchbar.text!
            }
        }
        
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        searchbar.resignFirstResponder()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchbar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        searchbar.endEditing(true)
        searchbar.isHidden = true
    }
    
    deinit
    {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
