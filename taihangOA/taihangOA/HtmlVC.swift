//
//  HtmlVC.swift
//  lejia
//
//  Created by X on 15/11/12.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import WebKit
import Cartography
import SwiftyJSON


class HtmlVC: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    
    var webView:WKWebView?
    var url:URL?
    var html:String=""
    var baseUrl:URL?
    
    var hideNavBar = false
    
    let topView = UIView()
    
    var tuanModel = TuanModel()

    func msgChanged(_ json:String) {
        
        let data=json.data(using: String.Encoding.utf8)
        
        do
        {
            let json = JSON.init(data: data!)
            HandleJSMsg.handle(obj: json, vc: self)
        }
        catch
        {
            print("js msg111: \(json)")
        }
    }
    
    func show()
    {
        if(webView == nil)
        {
            return
        }
        
        if(self.url != nil)
        {
            let request = URLRequest(url: url!)
            
//            request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "accept")
//            request.setValue("gzip, deflate, sdch, br", forHTTPHeaderField: "accept-encoding")
//            
//            request.setValue("zh-CN,zh;q=0.8", forHTTPHeaderField: "accept-language")
//            request.setValue("thw=cn; uc3=nk2=qAasmv1woFmbnA%3D%3D&id2=UNk%2BdFn9fBn4&vt3=F8dARV58qUAjLiE01cE%3D&lg2=VT5L2FSpMGV7TQ%3D%3D; lgc=%5Cu6C34%5Cu74F6%5Cu5EA7%5Cu5929%5Cu624D; tracknick=%5Cu6C34%5Cu74F6%5Cu5EA7%5Cu5929%5Cu624D; t=87376a53efcd86ced9b98e80373694c1; _cc_=WqG3DMC9EA%3D%3D; tg=0; miid=1384629793655383608; cna=/V66ETPb5TwCAQHEstu/RmQj; isg=At_f4gQj-qVObP65EKY6S6JIbjWp7DKJ3OcCg3EstA6VAP6CeRBcNxoYtqeE", forHTTPHeaderField: "cookie")
//            
//            request.setValue("1", forHTTPHeaderField: "upgrade-insecure-requests")
//            
//            request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36", forHTTPHeaderField: "UserAgent")
            
            
            XWaitingView.show()
            
            webView?.load(request as URLRequest)
        }
        else if(self.html != "")
        {
            XWaitingView.show()
            
            webView?.loadHTMLString(self.html, baseURL: baseUrl)
        }

    }
    
    func gotoBack()
    {
        XWaitingView.hide()
        
        if webView?.canGoBack == true
        {
            webView?.goBack()
        }
    }
    
    func reload()
    {
        webView?.reload()
        
//        if let currentURL = self.webView?.url {
//            let request = URLRequest(url: currentURL)
//            self.webView?.load(request)
//        }
//        else
//        {
//            if(self.url != nil)
//            {
//                let request = URLRequest(url: url!)
//                webView?.load(request)
//            }
//            else if(self.html != "")
//            {
//                webView?.loadHTMLString(self.html, baseURL: baseUrl)
//            }
//
//        }
    }
    
    override func pop() {
    
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "JSHandle")
        webView?.uiDelegate=nil
        webView?.navigationDelegate=nil
        webView?.stopLoading()
        webView=nil
        
        super.pop()
    }
    
    let scriptHandle = WKUserContentController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.view.backgroundColor = UIColor.white
        let config = WKWebViewConfiguration()
        
        topView.frame = CGRect.init(x: 0, y: 0, width: SW, height: 20)
        topView.backgroundColor = APPBlueColor
        
        scriptHandle.add(self, name: "JSHandle")
        
        let per = WKPreferences()
        per.javaScriptCanOpenWindowsAutomatically = true
        per.javaScriptEnabled = true
        
        config.preferences = per
        config.userContentController = scriptHandle
        
        
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        
        webView?.uiDelegate=self
        webView?.navigationDelegate=self
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        
        
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.white
        
//        webView?.evaluateJavaScript("navigator.userAgent", completionHandler: { (res, err) in
//            
//            let oldAgent = res as! String
//
//            print(oldAgent)
//            
//            let dic = ["UserAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"]
//            
//            UserDefaults.standard.register(defaults: dic)
//            
//            
//        })
        
        
        
        self.view.addSubview(webView!)
        
        constrain(webView!) { (view) in
            view.width == (view.superview?.width)!
            view.height == (view.superview?.height)!
            view.centerX == (view.superview?.centerX)!
            view.centerY == (view.superview?.centerY)!
        }
        
        self.show()
        
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let str = message.body as? String
        {
            self.msgChanged(str)
        }
        
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = "\(navigationAction.request.url!)"
        
        if (!url.has("http://") && !url.has("https://") && !url.has(".html"))
        {
            UIApplication.shared.openURL(navigationAction.request.url!)
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            
        } else {
            
            decisionHandler(WKNavigationActionPolicy.allow)
            
        }

 
        
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        XWaitingView.hide()
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        XWaitingView.hide()
        
//        DelayDo(3) {
//            
//            let doc = "document.getElementsByTagName('html')[0].innerHTML"
//            
//            webView.evaluateJavaScript(doc) { (info, err) in
//                
//                if(err != nil)
//                {
//                    print(err ?? "")
//                }
//                else
//                {
//                    print(info ?? "")
//                }
//                
//                print("!!!!!!!!!!!!-------------------------!!!!!!!!!!!!")
//                
//            }
//            
//        }
//
        
    }
    
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            
            completionHandler()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // 点击完成后，可以做相应处理，最后再回调js端
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        
        return nil
        
        
    }
    
    func toPicInfo()
    {
        let vc = HtmlVC()
        vc.hidesBottomBarWhenPushed = true
        
        let url = "http://tg01.sssvip.net/wap/index.php?ctl=deal_detail&act=app_index&data_id="+tuanModel.id
        
        if let u = url.url()
        {
            vc.url = u
        }
        
        vc.tuanModel = tuanModel
        vc.title = "图文详情"
        
        self.show(vc, sender: nil)
    }
    
    
    func doCollect()
    {
        if !checkIsLogin()
        {
            return
        }
        
        Api.do_collect(uid: DataCache.Share.User.id, id: tuanModel.id) {[weak self] (r) in
            
            if r == "收藏成功"
            {
                XMessage.show("收藏成功")
                self?.webView?.evaluateJavaScript("javascript:collectChange(1)", completionHandler: { (res, err) in
                    
                })
            }
            else
            {
                XMessage.show("取消收藏成功")
                self?.webView?.evaluateJavaScript("javascript:collectChange(0)", completionHandler: { (res, err) in
                    
                })
            }
            
        }
        
        
    }
    
    
    func doBuy()
    {
        let vc = "OrderSubmitVC".VC(name: "Main") as! OrderSubmitVC
        vc.model = tuanModel
        
        let nv = XNavigationController.init(rootViewController: vc)
        
        self.show(nv, sender: nil)
        
    }
    
    
    
    func addPopObserver(str:String)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(pop), name: NSNotification.Name(rawValue: str), object: nil)
    }
    
    func addReloadObserver(str:String)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: str), object: nil)
    }
    
    func dodeinit()
    {
        NotificationCenter.default.removeObserver(self)
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "JSHandle")
        webView?.uiDelegate=nil
        webView?.navigationDelegate=nil
        webView?.stopLoading()
        webView=nil
        scriptHandle.removeAllUserScripts()
        scriptHandle.removeScriptMessageHandler(forName: "JSHandle")
        
    }
    
    deinit
    {
        dodeinit()
        print("HtmlVC deinit !!!!!!!!!!!!!!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!NetConnected)
        {
            XMessage.Share.show("未检测到网络连接,请检查网络")
        }
        
        if hideNavBar
        {
            self.navigationController?.navigationBar.isHidden = true
            self.view.addSubview(topView)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        topView.removeFromSuperview()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
}
