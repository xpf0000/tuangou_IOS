//
//  MutalReactionMenuView.swift
//  lejia
//
//  Created by X on 15/9/21.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit

typealias reactionMenuBlock = (Array<ReactionMenuItemModel>,Int)->Void

@objc protocol ReactionMenuDelegate:NSObjectProtocol{
    //回调方法
    @objc optional func ReactionMenuChoose(_ arr:Array<ReactionMenuItemModel>,index:Int)
    
    @objc optional func ReactionTableHeight(_ table:UITableView,indexPath:IndexPath)->CGFloat
    
    @objc optional func ReactionTableCell(_ indexPath:IndexPath,cell:UITableViewCell,model:ReactionMenuItemModel)
    
    @objc optional func ReactionBeforeShow(_ view:ReactionMenuView)
}

class ReactionMenuItemModel :NSObject{
    
    var title:String=""
    var id:Int=0
    var sid = ""
    var img = ""

    var level = 0
    var pid = 0
    var fid = 0
    
    var obj:AnyObject?
    
}

class ReactionMenuView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var LineHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collection: UICollectionView!
    
    
    var block:reactionMenuBlock?
    
    weak var superView:UIView?
    
    var bgView: UIView=UIView(frame: CGRect(x: 0, y: 0, width: SW, height: 0))
    
    var tableBG: UIView = UIView(frame: CGRect(x: 0, y: 0, width: SW, height: 0))
    
    var titlesBack:Array<String>=[]
    var titles:Array<String>=[]
    
    var items:Array<Array<ReactionMenuItemModel>> = []
    
    var width:CGFloat=0.0
    var height:CGFloat=0.0
    var cellWidth:CGFloat=0.0
    var tableWidths:Array<Array<CGFloat>>=[];
    var selectRow:Int = -1
    var tapGR:UITapGestureRecognizer?
    var nowTable:UITableView?
    var tablesData:Array<Array<ReactionMenuItemModel>> = []
    
    weak var delegate:ReactionMenuDelegate?
    
    var onlyOne:Bool = false
    
    var tbWidth = SW
    var tbHeight = SH * 0.55
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initSelf()
    {
        let containerView:UIView=("ReactionMenuView".Nib().instantiate(withOwner: self, options: nil))[0] as! UIView
        
        let newFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        containerView.frame = newFrame
        self.addSubview(containerView)
        
        bottomLine.backgroundColor="d7d7d7".color()
        LineHeight.constant=0.4
        
        self.collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.bgView.backgroundColor=UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 0.5)
        self.bgView.isUserInteractionEnabled=true
        
    
        self.tableBG.backgroundColor=UIColor.white
        self.tableBG.layer.masksToBounds=true
        
        self.tableBG.layer.shadowOffset = CGSize(width: 0, height: 10); //设置阴影的偏移量
        self.tableBG.layer.shadowRadius = 5;  //设置阴影的半径
        self.tableBG.layer.shadowColor = UIColor.black.cgColor; //设置阴影的颜色为黑色
        self.tableBG.layer.shadowOpacity = 0.4; //设置阴影的不透明度
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(ReactionMenuView.hideDropDown))
        tapGR!.delegate=self;
        tapGR!.numberOfTapsRequired = 1;
        
    }
    
    func doSelect(_ indexPath:IndexPath)
    {
        self.collection.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        
        if(self.bgView.frame.size.height > 0)
        {
            self.hideDropDown()
            return
        }
        
        self.show(indexPath)
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initSelf()
        
    }
    
    func Block(_ block:@escaping reactionMenuBlock)
    {
        self.block = block
    }
    
    func setTable()
    {
        let frame=self.superview?.convert(self.frame, to: self.superView!)
        
        if(self.bgView.frame.size.height > 0)
        {
            self.hideDropDown()
            
            return
        }
        
        
        self.bgView.frame=CGRect(x: frame!.origin.x, y: frame!.origin.y+frame!.size.height, width: SW, height: 0)
        self.tableBG.frame=CGRect(x: frame!.origin.x, y: frame!.origin.y+frame!.size.height, width: tbWidth, height: 0)
        
        self.bgView.addGestureRecognizer(tapGR!)
        self.superView!.insertSubview(self.bgView, belowSubview: self)
        self.superView!.insertSubview(self.tableBG, belowSubview: self)
        
        if(self.selectRow < self.tableWidths.count)
        {
            let arr:Array<CGFloat>? = self.tableWidths[self.selectRow]
            if(arr != nil)
            {
                var i=0
                var c:CGFloat=0.0
                for w in arr!
                {
                    c=c+w
                    
                    let h = self.tbHeight > 0.0 ? self.tbHeight : SH*0.55-self.height-10
                    
                    let table:UITableView=UITableView(frame: CGRect(x: (c-arr![i])*SW, y: 0, width: SW*w, height: h))
                    
                    table.isUserInteractionEnabled = true;
                    table.isScrollEnabled = true;
                    table.bounces=true;
                    table.backgroundColor = UIColor.white
                    table.showsVerticalScrollIndicator=false;
                    table.showsHorizontalScrollIndicator=false;
                    table.separatorStyle=UITableViewCellSeparatorStyle.none;
                    
                    table.separatorInset=UIEdgeInsets.zero
                    table.layoutMargins=UIEdgeInsets.zero
                    
                    table.tag=100+i
                    let view:UIView = UIView()
                    view.backgroundColor = UIColor.clear
                    table.tableFooterView=view
                    table.tableHeaderView=view
                    
                    table.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
                    self.tableBG.addSubview(table)

                    table.delegate = self;
                    table.dataSource = self;
                    
                    if(i==0)
                    {
                        table.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
                    }
                    
                    i += 1
                }
            }
        }
        
        delegate?.ReactionBeforeShow?(self)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            self.bgView.frame.size.height=SH
            
            self.tableBG.frame.size.height = self.tbHeight
            
        }, completion: { (finish) -> Void in
            
            self.tableBG.layer.masksToBounds=false
        }) 
        
        
    }
    
    func hideDropDown()
    {
        self.tableBG.layer.masksToBounds=true
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            self.bgView.frame.size.height = 0.0
            self.tableBG.frame.size.height = 0.0
            
        }, completion: { (finish) -> Void in
            
            self.tablesData.removeAll(keepingCapacity: false)
            self.nowTable = nil
            self.tableBG.removeAllSubViews()
            self.tableBG.removeFromSuperview()
            self.bgView.removeFromSuperview()
            self.bgView.removeGestureRecognizer(self.tapGR!)
            self.selectRow = -1
        }) 
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(self.cellWidth == 0)
        {
            self.titlesBack=self.titles
            self.superView?.clipsToBounds=false;
            self.superView?.layer.masksToBounds=false;
            
            self.width=self.frame.size.width
            self.height=self.frame.size.height
            self.cellWidth=self.width/CGFloat(titles.count)
            self.collection.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: self.width/CGFloat(titles.count), height: self.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.contentView.removeAllSubViews()
        
        let title:String=self.titles[indexPath.row]
        
        let label:UILabel=UILabel(frame: CGRect(x: 0, y: 0, width: self.cellWidth, height: self.height))
        label.font=UIFont.systemFont(ofSize: 16)
        label.textAlignment=NSTextAlignment.center
        
        if indexPath.row == selectRow
        {
            label.textColor=APPBlueColor
        }
        else
        {
            label.textColor="333333".color()
        }
        
        label.text=title
        
        cell.contentView.addSubview(label)
        
        //MARK: - 优惠topButton里面的两条竖线
        if(indexPath.row != self.titles.count-1)
        {
            let line:UIView=UIView(frame: CGRect(x: self.cellWidth-0.4, y: 10, width: 0.4, height: self.height-20))
            line.backgroundColor=UIColor.gray
            cell.contentView.addSubview(line)
        }
        
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(self.bgView.frame.size.height > 0)
        {
            self.hideDropDown()
            return
        }
        
        self.show(indexPath)
    }
    
    func show(_ indexPath: IndexPath)
    {
        self.nowTable=nil
        self.selectRow=indexPath.row
        self.setTableDataSouce()
        self.setTable()
    }
    
    func setTableDataSouce()
    {
        if(self.items.count == 0 || self.selectRow >= self.items.count)
        {
            return
        }
        
        let arr:Array<ReactionMenuItemModel>=self.items[self.selectRow]
        
        if(self.nowTable == nil)
        {
            self.tablesData.removeAll(keepingCapacity: false)
            
            for i in 0..<self.tableWidths[self.selectRow].count
            {
                self.tablesData.append([])
                
                if(i==0)
                {
                    for item in arr
                    {
                        if(item.fid == 0 && item.level == i)
                        {
                            self.tablesData[i].append(item)
                        }
                    }
                }
                else
                {
                    let lastItem:ReactionMenuItemModel = self.tablesData[i-1][0]
                    
                    for item in arr
                    {
                        if(item.fid == lastItem.pid && item.level == i)
                        {
                            self.tablesData[i].append(item)
                        }
                    }
                    
                }
                
            }
            
            for view in self.tableBG.subviews
            {
                if(view is UITableView)
                {
                    (view as! UITableView).reloadData()
                }
            }
            
        }
        else
        {
            let index:Int=self.nowTable!.tag-100
            let model:ReactionMenuItemModel=self.tablesData[index][self.nowTable!.indexPathForSelectedRow!.row]
            
            self.tablesData.removeSubrange((index + 1)..<self.tableWidths[self.selectRow].count)
            
            for i in index+1..<self.tableWidths[self.selectRow].count
            {
                self.tablesData.append([])
                
                if(i==index+1)
                {
                    
                    for item in arr
                    {
                        if(item.fid == model.pid && item.level == i)
                        {
                            self.tablesData[i].append(item)
                        }
                    }
    
                }
                else
                {
                    
                    for item1 in self.tablesData[i-1]
                    {
                        for item in arr
                        {
                            if(item.fid == item1.pid && item.fid > 0 && item.level == i)
                            {
                                self.tablesData[i].append(item)
                            }
                        }
                    }
                }
                
                
            }
            
            for view in self.tableBG.subviews
            {
                if(view is UITableView)
                {
                    if(view.tag>100+index)
                    {
                        (view as! UITableView).reloadData()
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.separatorInset=UIEdgeInsets.zero
        cell.layoutMargins=UIEdgeInsets.zero
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tag:Int=tableView.tag-100
        
        let model:ReactionMenuItemModel=tablesData[tag][indexPath.row]

        var cell:UITableViewCell?=tableView.dequeueReusableCell(withIdentifier: "tableCell")
        if(cell == nil)
        {
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tableCell")
        }
        
        cell!.contentView.removeAllSubViews()
        cell!.textLabel?.textAlignment=NSTextAlignment.center
        cell!.selectedBackgroundView=UIView(frame: cell!.frame)
        
        if(tableView.tag % 2 == 0)
        {
            cell!.backgroundColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
            cell!.selectedBackgroundView?.backgroundColor=UIColor.white
            
        }
        else
        {
            cell!.backgroundColor=UIColor.white
            cell!.selectedBackgroundView?.backgroundColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
            
        }
        
        cell?.textLabel?.text=model.title
        
        delegate?.ReactionTableCell?(indexPath,cell:cell!, model: model)
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let h = delegate?.ReactionTableHeight?(tableView, indexPath: indexPath)
        {
            return h
        }
        else
        {
            return 44
        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tag:Int=tableView.tag-100
        
        if(tag < tablesData.count)
        {
            return tablesData[tag].count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.nowTable=tableView
        
        if(tableView.tag-100 <  self.tableWidths[self.selectRow].count-1)
        {
            self.setTableDataSouce()
        }
        else
        {
            if(onlyOne && indexPath.row==0)
            {
                return
            }
            
            var resultArr:Array<ReactionMenuItemModel>=[]
            
            var changed:Bool=false
            
            for i in 0..<self.tableWidths[self.selectRow].count
            {
                let table:UITableView=self.tableBG.viewWithTag(100+i) as! UITableView
                var index:Int?=table.indexPathForSelectedRow?.row
                index = index == nil ? 0 : index
                
                resultArr.append(self.tablesData[i][index!])
                
                if(self.tablesData[i][index!].id>0 || self.tablesData[i][index!].sid != "")
                {
                    self.titles[self.selectRow]=self.tablesData[i][index!].title
                    changed=true
                }
            }
            
            if(!changed)
            {
                self.titles[self.selectRow]=self.titlesBack[self.selectRow]
            }
            
            self.collection.reloadData()
            
            if(self.block != nil)
            {
                self.block!(resultArr,selectRow)
            }
            
            self.delegate?.ReactionMenuChoose?(resultArr, index: selectRow)
            
            self.hideDropDown()
        }
        
        
    }
    
    func reSetColumn(_ c:Int)
    {
        self.titles[c]=self.titlesBack[c]
        self.collection.reloadData()
    }
    
    
    
    deinit
    {
        self.block = nil
        self.delegate = nil
        self.titles.removeAll(keepingCapacity: false)
        self.items.removeAll(keepingCapacity: false)
        self.tableWidths.removeAll(keepingCapacity: false)
        self.tablesData.removeAll(keepingCapacity: false)
        self.nowTable = nil
        self.tableBG.removeAllSubViews()
        self.bgView.removeGestureRecognizer(self.tapGR!)
    }
    
}
