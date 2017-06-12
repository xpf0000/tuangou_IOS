//
//  XHorizontalswift
//  XHorizontalView
//
//  Created by X on 16/5/17.
//  Copyright © 2016年 XHorizontalView. All rights reserved.
//

import UIKit

class XHorizontalMainView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    let mainLayout = UICollectionViewFlowLayout()
    
    weak var menu:XHorizontalMenuView?
        {
        didSet
        {
            if menu?.main != self
            {
                menu?.main = self
                doRefresh()
            }
        }
    }
    
    func doRefresh()
    {
        DispatchQueue.main.async {
            
            self.reloadData()
        }
    }
    
    
    fileprivate var block:XHorizontalMenuBlock?
    
    func selectBlock(_ b:@escaping XHorizontalMenuBlock)
    {
        self.block = b
    }
    
    var selectIndex : Int = 0
        {
        didSet
        {
            block?(selectIndex)
            
            selectItem(at: IndexPath(row: self.selectIndex, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
            
        }
    }
    
    
    var menuArr:[XHorizontalMenuModel] = []
        {
        didSet
        {
            self.changeUI()
        }
    }
    
    
    var UIChanged:Bool = false
        {
        willSet
        {
            if newValue != UIChanged
            {
                changeUI()
            }
            
        }
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setValue(true, forKey: "UIChanged")
        
    }
    
    func changeUI()
    {
        let size = (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize
        
        if size?.width != frame.size.width || size?.height != frame.size.height
        {
            (self.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: frame.size.width, height: frame.size.height)
        }
        
        doRefresh()
        
    }
    
    func initSelf()
    {
        
        mainLayout.scrollDirection = .horizontal
        mainLayout.minimumLineSpacing = 0.0
        mainLayout.minimumInteritemSpacing = 0.0
        mainLayout.itemSize = CGSize(width: frame.size.width, height: frame.size.height)
        
        collectionViewLayout = mainLayout
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeUI), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.white
        bounces = true
        clipsToBounds = true
        layer.masksToBounds = true
        isPagingEnabled = true
        delegate = self
        dataSource = self
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "mainViewCell")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
        
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        initSelf()
        
    }
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: UICollectionViewLayout())
        
        self.initSelf()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menuArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainViewCell", for: indexPath)
        
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        
        let obj = menuArr[indexPath.row]
        
        if let view = obj.view
        {
            view.frame = CGRect.zero
            cell.contentView.addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints=false
            
            let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
            
            let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: cell.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            
            let Leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: cell.contentView, attribute: .leading, multiplier: 1.0, constant: 0.0)
            
            let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: cell.contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            
            cell.contentView.addConstraints([top,bottom,Leading,trailing])
            
        }
        
        return cell
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if menu == nil {return}
        let t = scrollView.contentOffset.x / frame.size.width
        menu?.offy = t
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentPage : Int = Int(floor((scrollView.contentOffset.x - frame.size.width/2)/frame.size.width))+1;
        
        if(menu?.selectIndex != currentPage)
        {
            menu?.lastIndex = currentPage;
            menu?.selectIndex=currentPage;
            menu?.lastIndex = currentPage;
        }
        
        selectIndex = currentPage;
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        menu?.taped = false
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
}
