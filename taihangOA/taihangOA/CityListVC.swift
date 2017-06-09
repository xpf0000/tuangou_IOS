//
//  CityListVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/9.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CityListVC: UIViewController ,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var tableview: UITableView!
    
    var first = false
    
    var baseModel:CityModel = CityModel()
    
    var model:CityModel = CityModel()
    {
        didSet
        {
            titleIndexs.removeAll(keepingCapacity: false)
            titleIndexs.append("#")
            for item in model.city_list
            {
                titleIndexs.append(item.Letter)
            }
        }
    }
    
    var pcity = ""
    
    var block:XAlertViewBlock?
    
    var titleIndexs:[String] = ["#"]

    func onChoose(b:@escaping XAlertViewBlock)
    {
        self.block = b
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!first)
        {
            addBackButton()
        }
        
        searchbar.addEndButton()
        searchbar.layer.masksToBounds = true
        
        let btn = UIButton.init(frame: CGRect.init(x: SW-35, y: (44-22)/2, width: 22, height: 22))
        btn.setBackgroundImage("brefresh.png".image(), for: .normal)
        btn.addTarget(self, action: #selector(refreshcity), for: .touchUpInside)

        let rightB = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = rightB
        
        tableview.keyboardDismissMode = .onDrag
        tableview.register("CityListPostionCell".Nib(), forCellReuseIdentifier: "CityListPostionCell")
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let view = UIView()
        tableview.tableFooterView = view
        tableview.tableHeaderView = view
        
        getData()
        refreshcity()

    }
    
    
    func refreshcity()
    {
       
        XPosition.Share.getLocationInfo { [weak self](res) in
            
            XPosition.Share.stop()
            if let str = res?.addressDetail.city
            {
                self?.pcity = str
                self?.tableview.reloadData()
            }
 
        }
        
    }
    
        
    
    func getData()
    {
        Api.city_app_index { [weak self](model) in
            self?.baseModel = model
            self?.model = model
            
            self?.tableview.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return model.city_list.count+1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0)
        {
            return 1
        }
        else
        {
            return model.city_list[section-1].items.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 44.0
    
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: SW, height: 40.0)
        view.backgroundColor = "eeeeee".color()
        
        let label = UILabel()
        label.frame = CGRect(x: 12, y: 0, width: SW-12, height: 40.0)
        view.addSubview(label)
        
        if(section == 0)
        {
            label.text = "当前定位城市"
            label.textColor = "333333".color()
        }
        else
        {
            label.text = model.city_list[section-1].Letter
            label.textColor = "666666".color()
        }
        
        return view
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return titleIndexs
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0)
        {
            let cell = tableview.dequeueReusableCell(withIdentifier: "CityListPostionCell", for: indexPath) as! CityListPostionCell
            cell.pcity = pcity
            return cell
        }
        else
        {
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = model.city_list[indexPath.section-1].items[indexPath.row].name
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.section == 0)
        {
            var bean : ItemsBean?
            for item in baseModel.city_list
            {
                for v in item.items
                {
                    if(v.name.has(pcity) || pcity.has(v.name))
                    {
                        bean = v
                    }
                }
                
            }
            
            if bean != nil
            {
                DataCache.Share.city = bean!
                DataCache.Share.city.save()
                self.block?()
                self.pop()
            }
            else
            {
                XMessage.Share.show("该城市暂未开通同城百家站点，请选择其他城市")
            }
            
        }
        else
        {
            DataCache.Share.city = model.city_list[indexPath.section-1].items[indexPath.row]
            DataCache.Share.city.save()
            self.block?()
            self.pop()
        }
        
    }
    
    
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        doSearch()
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEdit()
        //doSearch()
        
    }
    
    func doSearch()
    {
        let key = searchbar.text!.lowercased()
        
        if(key == "")
        {
            model = baseModel
            tableview.reloadData()
            return
        }

        let searchRes = CityModel()
        
        for item in baseModel.city_list
        {

            let itemBean = CityListBean()
            itemBean.Letter = item.Letter
            
            for v in item.items
            {
                if(v.name.lowercased().has(key) || v.uname.lowercased().has(key))
                {
                    itemBean.items.append(v)
                }
            }
            
            if itemBean.items.count > 0
            {
                searchRes.city_list.append(itemBean)
            }
            
        }
        
        model = searchRes
        
        tableview.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
}
