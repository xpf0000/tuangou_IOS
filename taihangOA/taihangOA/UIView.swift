//
//  UIView.swift
//  swiftTest
//
//  Created by X on 15/3/14.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit

private var XCornerRadiusKey:CChar = 0

class XCornerRadiusModel: NSObject {
    
    var BorderSidesType:XBorderSidesType = []
    var CornerRadiusType:UIRectCorner = []
    var CornerRadius:CGFloat = 0.0
    var FillPath:Bool = false
    var StrokePath:Bool = false
    var FillColor:UIColor?
    var StrokeColor:UIColor = UIColor.clear
    var BorderLineWidth : CGFloat = 1.0
    
}

struct XBorderSidesType : OptionSet {
    
    let rawValue:Int

    static var None: XBorderSidesType = XBorderSidesType(rawValue: 1 << 0)
    static var Left: XBorderSidesType = XBorderSidesType(rawValue: 1 << 1)
    static var Top: XBorderSidesType = XBorderSidesType(rawValue: 1 << 2)
    static var Right: XBorderSidesType = XBorderSidesType(rawValue: 1 << 3)
    static var Bottom: XBorderSidesType = XBorderSidesType(rawValue: 1 << 4)
    static var All: XBorderSidesType = XBorderSidesType(rawValue: 1 << 5)
    
}

extension UIView
{
    
    var XCornerRadius:XCornerRadiusModel?
    {
        get
        {
            let r = objc_getAssociatedObject(self, &XCornerRadiusKey) as? XCornerRadiusModel
            
            return r
        }
        set {
            
            newValue?.FillColor = newValue?.FillColor ?? backgroundColor
            
            newValue?.FillColor = newValue?.FillColor ?? UIColor.clear
            
            self.willChangeValue(forKey: "XCornerRadiusKey")
            objc_setAssociatedObject(self, &XCornerRadiusKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValue(forKey: "XCornerRadiusKey")
            
            backgroundColor = UIColor.clear
            
            setNeedsDisplay()
            
        }
        
    }
    
    func drawCornerRadius(_ rect:CGRect)
    {
        
        if let m = XCornerRadius
        {
            let  halfLineWidth = m.BorderLineWidth / 2.0
        
            let topInsets = (m.BorderSidesType.contains(.Top) || m.BorderSidesType.contains(.All)) ? halfLineWidth : 0.0
            
            let leftInsets = (m.BorderSidesType.contains(.Left) || m.BorderSidesType.contains(.All)) ? halfLineWidth : 0.0
            
            let rightInsets = (m.BorderSidesType.contains(.Right) || m.BorderSidesType.contains(.All)) ? halfLineWidth : 0.0
            
            let bottomInsets = (m.BorderSidesType.contains(.Bottom) || m.BorderSidesType.contains(.All)) ? halfLineWidth : 0.0
            
            let insets = UIEdgeInsetsMake(topInsets, leftInsets, bottomInsets, rightInsets)
            
            print("rect: \(rect)")
            
            print("insets: \(insets)")
            
            let properRect = UIEdgeInsetsInsetRect(rect, insets)
            
            print("properRect: \(properRect)")
            
            let c = UIGraphicsGetCurrentContext()
            
            if c == nil {
                
                return
                
            }
            
            c!.setShouldAntialias(true)
            
            if m.StrokePath
            {
                
                c!.setLineCap(.round)
                c!.setLineWidth(m.BorderLineWidth)
                
                c!.setStrokeColor(m.StrokeColor.cgColor);
                c!.setFillColor(m.FillColor!.cgColor)
                
                addFillPath(c!, rect: properRect,m: m)
                
                c!.fillPath();
                
                addStrokePath(c!, rect: properRect,m: m)
                
                c!.strokePath();
                
                
                return
            }
            
            if m.FillPath
            {
                c!.setFillColor(m.FillColor!.cgColor)
                
                addFillPath(c!, rect: properRect,m: m)
                
                c!.fillPath();
            }
            
            
            
        }
        
        
        
        
    }
    
    fileprivate func addFillPath(_ c:CGContext,rect:CGRect,m:XCornerRadiusModel)
    {
        let minx = rect.minX
        let midx = rect.midX
        let maxx = rect.maxX
        
        let miny = rect.minY
        let midy = rect.midY
        let maxy = rect.maxY
        
        
        c.move(to: CGPoint(x: minx, y: midy))
        
        
        if (m.CornerRadiusType.contains(.topLeft)) {
            
            c.addArc(tangent1End: CGPoint.init(x: minx, y: miny), tangent2End: CGPoint.init(x: midx, y: miny), radius: m.CornerRadius)
            c.addLine(to: CGPoint(x: midx, y: miny));
            
        }
        else{
            
            c.addLine(to: CGPoint(x: minx, y: miny))
        }
        
        if (m.CornerRadiusType.contains(.topRight)) {
            c.addArc(tangent1End: CGPoint.init(x: maxx, y: miny), tangent2End: CGPoint.init(x: maxx, y: midy), radius: m.CornerRadius)
            c.addLine(to: CGPoint(x: maxx, y: midy))
        }
        else{
            
            c.addLine(to: CGPoint(x: maxx, y: miny))
        }
        
        if (m.CornerRadiusType.contains(.bottomRight)) {
            
            c.addArc(tangent1End: CGPoint.init(x: maxx, y: maxy), tangent2End: CGPoint.init(x: midx, y: maxy), radius: m.CornerRadius)
            c.addLine(to: CGPoint(x: midx, y: maxy))
            
        }
        else{
            
            c.addLine(to: CGPoint(x: maxx, y: maxy))
        }
        
        if (m.CornerRadiusType.contains(.bottomLeft)) {
            c.addArc(tangent1End: CGPoint.init(x: minx, y: maxy), tangent2End: CGPoint.init(x: minx, y: midy), radius: m.CornerRadius)
            c.addLine(to: CGPoint(x: minx, y: midy))
        }
        else{
            
            c.addLine(to: CGPoint(x: minx, y: maxy))
            
        }
        
        c.closePath()
        
    }
    
    fileprivate func addStrokePath(_ c:CGContext,rect:CGRect,m:XCornerRadiusModel)
    {
        let minx = rect.minX
        let midx = rect.midX
        let maxx = rect.maxX
        
        let miny = rect.minY
        let midy = rect.midY
        let maxy = rect.maxY
        
        
        if m.BorderSidesType.contains(.Left) || m.BorderSidesType.contains(.All)
        {
            
            if (m.CornerRadiusType.contains(.bottomLeft))
            {
                c.move(to: CGPoint(x: minx, y: maxy-m.CornerRadius))
                
                c.addArc(center: CGPoint.init(x: minx+m.CornerRadius, y: maxy-m.CornerRadius), radius: m.CornerRadius, startAngle: CGFloat(Double.pi), endAngle: 135.0*CGFloat(Double.pi/180.0), clockwise: true)
                
                c.move(to: CGPoint(x: minx, y: maxy-m.CornerRadius))
            }
            else
            {
                c.move(to: CGPoint(x: minx, y: maxy))
            }
            
            
            if (m.CornerRadiusType.contains(.topLeft))
            {
                c.addLine(to: CGPoint(x: minx, y: miny+m.CornerRadius))
                
                c.addArc(center: CGPoint.init(x: minx+m.CornerRadius, y: miny+m.CornerRadius), radius: m.CornerRadius, startAngle: CGFloat(Double.pi), endAngle: 225.0*CGFloat(Double.pi/180.0), clockwise: false)
            
            }
            else{
                
                c.addLine(to: CGPoint(x: minx, y: miny))
            }
            
        }
        
        
        if m.BorderSidesType.contains(.Top) || m.BorderSidesType.contains(.All)
        {
            
            if (m.CornerRadiusType.contains(.topLeft))
            {
                c.move(to: CGPoint(x: minx+m.CornerRadius, y: miny))
                
                c.addArc(center: CGPoint.init(x: minx+m.CornerRadius, y: miny+m.CornerRadius), radius: m.CornerRadius, startAngle: 270.0*CGFloat(Double.pi/180.0), endAngle: 225.0*CGFloat(Double.pi/180.0), clockwise: true)

                c.move(to: CGPoint(x: minx+m.CornerRadius, y: miny))
            }
            else
            {
                c.move(to: CGPoint(x: minx, y: miny))
            }
            
            if (m.CornerRadiusType.contains(.topRight))
            {
                c.addLine(to: CGPoint(x: maxx-m.CornerRadius, y: miny))
                
                c.addArc(center: CGPoint.init(x: maxx-m.CornerRadius, y: miny+m.CornerRadius), radius: m.CornerRadius, startAngle: 270.0*CGFloat(Double.pi/180.0), endAngle: 315.0*CGFloat(Double.pi/180.0), clockwise: false)
                
            }
            else{
                
                c.addLine(to: CGPoint(x: maxx, y: miny))
            }
            
        }
        
        
        if m.BorderSidesType.contains(.Right) || m.BorderSidesType.contains(.All)
        {
            
            if (m.CornerRadiusType.contains(.topRight))
            {
                c.move(to: CGPoint(x: maxx, y: miny+m.CornerRadius))
                
                c.addArc(center: CGPoint.init(x: maxx-m.CornerRadius, y: miny+m.CornerRadius), radius: m.CornerRadius, startAngle: 360.0*CGFloat(Double.pi/180.0), endAngle: 315.0*CGFloat(Double.pi/180.0), clockwise: true)
                
                c.move(to: CGPoint(x: maxx, y: miny+m.CornerRadius))
            }
            else
            {
                c.move(to: CGPoint(x: maxx, y: miny))
            }
            
            if (m.CornerRadiusType.contains(.bottomRight))
            {
                c.addLine(to: CGPoint(x: maxx, y: maxy-m.CornerRadius))
                
                c.addArc(center: CGPoint.init(x: maxx-m.CornerRadius, y: maxy-m.CornerRadius), radius: m.CornerRadius, startAngle: 0, endAngle: 45.0*CGFloat(Double.pi/180.0), clockwise: false)
                
            }
            else{
                
                c.addLine(to: CGPoint(x: maxx, y: maxy))
            }
            
        }
        
        if m.BorderSidesType.contains(.Bottom) || m.BorderSidesType.contains(.All)
        {
            
            if (m.CornerRadiusType.contains(.bottomRight))
            {
                c.move(to: CGPoint(x: maxx-m.CornerRadius, y: maxy))
                
                c.addArc(center: CGPoint.init(x: maxx-m.CornerRadius, y: maxy-m.CornerRadius), radius: m.CornerRadius, startAngle: 90.0*CGFloat(Double.pi/180.0), endAngle: 45.0*CGFloat(Double.pi/180.0), clockwise: true)
                
                c.move(to: CGPoint(x: maxx-m.CornerRadius, y: maxy))
            }
            else
            {
                c.move(to: CGPoint(x: maxx, y: maxy))
            }
            
            if (m.CornerRadiusType.contains(.bottomLeft))
            {
                c.addLine(to: CGPoint(x: minx+m.CornerRadius, y: maxy))
                
                c.addArc(center: CGPoint.init(x: minx+m.CornerRadius, y: maxy-m.CornerRadius), radius: m.CornerRadius, startAngle: 90.0*CGFloat(Double.pi/180.0), endAngle: 135.0*CGFloat(Double.pi/180.0), clockwise: false)
                
            }
            else{
                
                c.addLine(to: CGPoint(x: minx, y: maxy))
            }
            
        }
        
        
        
        
        
    }

    
    
    func endEdit()
    {
        self.endEditing(true)
    }
    
    
    func addEndButton()
    {
        
        let swidth = UIScreen.main.bounds.size.width
        
        // 键盘添加一下Done按钮
        let topView : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: swidth, height: 38))
        
        topView.layer.shadowColor = UIColor.clear.cgColor
        topView.layer.masksToBounds = true
        topView.isTranslucent = true
        
        let btn = UIButton(type: .custom)
        
        btn.setTitleColor("007AFF".color(), for: UIControlState())
        btn.setTitle("完成", for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        
        btn.frame = CGRect(x: swidth-60, y: 0, width: 48, height: 38)
        topView.addSubview(btn)
        
        btn.click {[weak self] (b) in
            
            self?.endEdit()
        }
        
        self.setValue(topView, forKey: "inputAccessoryView")
    }

    
    
    var rootView:UIView{
        
        var rootview=self
        while ((rootview.superview) != nil) {
            
            if (rootview.superview is UIWindow) {
                
                break
                
            }
            
            rootview = rootview.superview!
            
        }
        
        return rootview
    }
    
    var viewController:UIViewController?
        {
            var next:UIView? = self.superview == nil ? self : self.superview
            
            while(!(next is UIWindow) && next != nil)
            {
                let nextResponder:UIResponder? = next?.next
                
                if (nextResponder is UIViewController)
                {
                    return nextResponder as? UIViewController
                }
                
                next=next?.superview
            }
            
            
            return nil
        }
    
    
    func removeAllSubViews()
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }

    //旋转 时间 角度
    func revolve(_ time:TimeInterval,angle:CGFloat)
    {
        if(angle == 0.0)
        {
            UIView.animate(withDuration: time, animations: { () -> Void in
                self.transform=CGAffineTransform.identity
            })
        }
        else
        {
            UIView.animate(withDuration: time, animations: { () -> Void in
                self.transform=CGAffineTransform(rotationAngle: CGFloat(Double.pi)*CGFloat(angle))
            })
        }
        
       

    }
    
    
    
    //抖动动画
    func shake()
    {
        // 获取到当前的View
        
        let viewLayer:CALayer = self.layer;
        
        // 获取当前View的位置
        
        let position = viewLayer.position;
        
        // 移动的两个终点位置
        
        let x = CGPoint(x: position.x + 8, y: position.y);
        
        let y = CGPoint(x: position.x - 8, y: position.y);
        
        let  animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.fromValue = NSValue(cgPoint: x)
        animation.toValue = NSValue(cgPoint: y)
        animation.autoreverses = true
        animation.duration = 0.05
        animation.repeatCount = 4
        viewLayer.add(animation, forKey: nil)
        
    }
    
    func alertAnimation(_ dur:TimeInterval,delegate:AnyObject?)
    {
        let  animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = dur;
  
        animation.isRemovedOnCompletion = false;
        
        animation.fillMode = kCAFillModeForwards;
        
        var values : Array<AnyObject> = []
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //animation.delegate = delegate
        self.layer.add(animation, forKey: nil)
     
    }
    
    func bounceAnimation(_ dur:TimeInterval,delegate:AnyObject?)
    {
        let  animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = dur;
        
        animation.isRemovedOnCompletion = false;
        
        animation.fillMode = kCAFillModeForwards;
        
        var values : Array<AnyObject> = []
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(2.0, 2.0, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //animation.delegate = delegate
        self.layer.add(animation, forKey: nil)
        
    }
    
    
    static func printAllSubView(_ v:UIView)
    {
        for item in v.subviews
        {
            //print(item)
            if item.subviews.count > 0
            {
                printAllSubView(item)
            }
        }
        
    }
    
    static func findTableView(_ v:UIView)->UITableView?
    {
        if v is UITableView
        {
            return v as? UITableView
        }
        
        if v.superview != nil
        {
            return findTableView(v.superview!)
        }
        else
        {
            return nil
        }
        
    }
    
    
    
    
    
}
