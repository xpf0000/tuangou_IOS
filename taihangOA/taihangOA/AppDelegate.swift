//
//  AppDelegate.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Reachability

let netcheck = Reachability()!
var mapManager:BMKMapManager?
var mapStarted = false

var NetConnected = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate,WXApiDelegate {

    var window: UIWindow?

    func onMessageReceived(_ notification:Notification)
    {
//        if let message = notification.object as? CCPSysMessage
//        {
//            let title = String.init(data: message.title, encoding: String.Encoding.utf8)
//            
//            let body = String.init(data: message.body, encoding: String.Encoding.utf8)
//            
//            print("Receive message title: \(title) | content: \(body)")
        
//            if let str = title,let content = body
//            {
//                if str == "账号在其它设备已登录"
//                {
//                    let arr = content.split("|")
//                    
//                    if(DataCache.Share.User.id == arr[0] && DataCache.Share.User.token != "" && DataCache.Share.User.token != arr[1])
//                    {
//                        let alert = UIAlertView(title: "提醒", message: "您的账户已在其他设备登录", delegate: self, cancelButtonTitle: "确定")
//                        alert.show()
//                    }
//  
//                }
//                else
//                {
//                    NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "NewDaiban")))
//                    let alert = UIAlertView(title: "提醒", message: title, delegate: nil, cancelButtonTitle: "确定")
//                    alert.show()
//                }
//            }
            
            
        //}
        
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        //DataCache.Share.User.unRegistNotice()
        DataCache.Share.User.reset();
        
    }
    
    
    func initCloudPush()
    {
        
//        CloudPushSDK.asyncInit("23744972", appSecret: "6295ae0f5198f3795b85d23d531e7ad4") { (res) in
//            
//            if let r = res
//            {
//                if(r.success)
//                {
//                    print("CloudPushSDK.asyncInit success !!!!!!!!!!!!")
//                }
//                else
//                {
//                    print(r.error ?? "阿里云注册失败")
//                }
//            }
//            else
//            {
//                print("阿里云注册失败")
//            }
//            
//        }
//        
//        CloudPushSDK.turnOnDebug()
    }
    
    func onResp(_ resp: BaseResp!) {
        
        if resp is PayResp
        {
            switch resp.errCode {
            case WXSuccess.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixin_pay_result"), object: "支付成功!")
            case WXErrCodeUserCancel.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixin_pay_result"), object: "支付取消!")
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixin_pay_result"), object: "支付失败!请重新支付!")
            }
        }
        
    }
    
 
    
    func RegistPushNotice()
    {
        let settings:UIUserNotificationSettings=UIUserNotificationSettings(types: [.alert,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        RegistPushNotice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onMessageReceived(_:)), name: NSNotification.Name(rawValue: "CCPDidReceiveMessageNotification"), object: nil)
        
        initCloudPush()
        
        mapManager = BMKMapManager()
        if let res = mapManager?.start("xrOkkW4WGCXgiL0Vv6lw9APtxIR6UK5q", generalDelegate: nil)
        {
            if(!res)
            {
                print("百度地图加载失败")
                mapStarted = false
            }
            else
            {
                
                print("百度地图加载成功 ！！！！！！！！！！")
                
                mapStarted = true
                
                XPosition.Share.getCoordinate(block: { [weak self](res) in
                })
                
            }

        }
        initShareSDK()
        //CloudPushSDK.sendNotificationAck(launchOptions)
        
        WXApi.registerApp("wxec4f19cde6fa4597", withDescription: "com.x.tcbjpt")
        

        netcheck.whenReachable = { reachability in
            DispatchQueue.main.async {
                NetConnected = true
            }
        }
        
        netcheck.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                NetConnected = false
            }
        }
        
        do {
            try netcheck.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        return true
    }
    
    
    
    
    func initShareSDK()
    {
        
        
        ShareSDK.registerApp("ccae6a09a59e", activePlatforms:[
            SSDKPlatformType.typeWechat.rawValue,
            SSDKPlatformType.typeQQ.rawValue],
                             onImport: { (platform : SSDKPlatformType) in
                                switch platform
                                {
                                case SSDKPlatformType.typeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                case SSDKPlatformType.typeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                default:
                                    break
                                }
                                
        }) { (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
            
            switch platform
            {
           
            case SSDKPlatformType.typeWechat:
                //设置微信应用信息
                appInfo?.ssdkSetupWeChat(byAppId: "wx75043ca8e647d5d3", appSecret: "10e58beee4fc530a891f1e90a38c57bb")
                
            case SSDKPlatformType.typeQQ:
                //设置QQ应用信息
                appInfo?.ssdkSetupQQ(byAppId: "1106233806", appKey: "NdPnYslFfLQ9YJzt", authType: SSDKAuthTypeBoth)
                
            default:
                break
            }
            
        }
        
        
    }

    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
//        CloudPushSDK.registerDevice(deviceToken) { (res) in
//            
//            if let r = res
//            {
//                if(r.success)
//                {
//                    if(DataCache.Share.User.id == "")
//                    {
//                        CloudPushSDK.removeAlias(nil) { (res) in
//                            
//                            print(res.debugDescription)
//                            print("清空阿里推送!!!!!!!")
//                            
//                        }
//
//                    }
//                    
//                    
//                    print("阿里云注册成功 Token: \(deviceToken.description)")
//                }
//                else
//                {
//                    print(r.error ?? "阿里云注册失败")
//                }
//            }
//            else
//            {
//                print("阿里云注册失败")
//            }
//            
//        }

        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        //print("阿里云注册失败 error: \(error)")
        
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("收到推送: \(userInfo)")
        
        //CloudPushSDK.sendNotificationAck(userInfo)
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.\
        
        print("applicationWillEnterForeground !!!!!!!!!")
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
        print("applicationDidBecomeActive !!!!!!!!!")
        
        "ApplicationDidBecomeActive".postNotice()
            
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.host == "safepay"
        {
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (dic) in
                print(dic ?? [])
            })
        }
        
        if "\(url)".has("wxec4f19cde6fa4597://pay")
        {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        
        if url.host == "safepay"
        {
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (dic) in
                print(dic ?? [])
            })
        }
        
        if "\(url)".has("wxec4f19cde6fa4597://pay")
        {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        return true
    }
    
    

}

