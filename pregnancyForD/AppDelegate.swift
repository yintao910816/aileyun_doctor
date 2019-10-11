//
//  AppDelegate.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/9.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
    
    var Login : Bool?
    
    lazy var space : (topSpace : CGFloat, bottomSpace : CGFloat) = {
        let s = HC_getTopAndBottomSpace()
        return s
    }()
    
    // 设计成单例
    static let shareIntance : AppDelegate = {
        let appDelegate = AppDelegate()
        return appDelegate
    }()

    
    var defaultViewController : UIViewController {
        var isLogin : Bool
        
        let dic = UserDefaults.standard.value(forKey: kCurrentUser)
        
        if let dic = dic{
            UserManager.shareIntance.currentUser = UserModel.init(dic as! [String : Any])
            isLogin = true
            Login = true
        }else{
            isLogin = false
            Login = false
        }
        
        let loginVC = BaseNavigationController.init(rootViewController: LoginViewController())
        
        return isLogin ? MainTabBarController() :  loginVC
    }



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion = infoDictionary! ["CFBundleShortVersionString"] as? NSString
        MobClick.setVersion(Int(majorVersion?.intValue ?? 1))
        
        MobClick.setLogEnabled(true)
        
        let obj = UMAnalyticsConfig.init()
        obj.appKey = "578b08cd67e58e4716005017"
        MobClick.start(withConfigure: obj)
        
        UMessage.start(withAppkey:"5939f6e4aed1797af30014b5", launchOptions: launchOptions)
        UMessage.setLogEnabled(false)
        UMessage.setAutoAlert(false)
        
        application.registerForRemoteNotifications()
        //授权
        self.registerNotification()
        
        WXApi.registerApp(weixinAppid)
        
        TencentOAuth.init(appId: QQAppid, andDelegate: nil)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func registerNotification(){
        if let receKey = UserDefaults.standard.value(forKey: kReceiveRemoteNote){
            let receNote = receKey as! Bool
            if receNote == false {
                return
            }
        }

        if #available(iOS 10.0, *) {
            // 使用 UNUserNotificationCenter 来管理通知
            let center = UNUserNotificationCenter.current()
            //监听回调事件
            center.delegate = self
            
            //iOS 10 使用以下方法注册，才能得到授权
            center.requestAuthorization(options: [UNAuthorizationOptions.alert,UNAuthorizationOptions.badge,UNAuthorizationOptions.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                if (granted) {
                    //点击允许
                    HCPrint(message: "注册通知成功")
                    UserDefaults.standard.set(true, forKey: kReceiveRemoteNote)
                    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
                    center.getNotificationSettings(completionHandler:{(settings:UNNotificationSettings) in
                        HCPrint(message: "UNNotificationSettings")
                    })
                } else {
                    //点击不允许
                    UserDefaults.standard.set(false, forKey: kReceiveRemoteNote)
                    HCPrint(message: "注册通知失败")
                }
            })
        } else {
            // Fallback on earlier versions
            let type = UIUserNotificationType.alert.rawValue | UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue
            let set = UIUserNotificationSettings.init(types: UIUserNotificationType(rawValue: type), categories: nil)
            UIApplication.shared.registerUserNotificationSettings(set)
        }

    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        HCPrint(message: url)
        
        if url.absoluteString.contains("tencent1106202365"){
            TencentOAuth.handleOpen(url)
            let vc = ShowShareViewController()
            return QQApiInterface.handleOpen(url, delegate: vc)
        }else{
            HCPrint(message: "other")
            return WXApi.handleOpen(url, delegate: self)
        }
        
    }
    
    func onResp(_ resp: BaseResp!) {
        
        if resp.isKind(of: SendAuthResp.self) {
            if resp.errCode == 0{
                let obj = resp as! SendAuthResp
                // 调本地接口获取用户信息
                HttpClient.shareIntance.getWeixinOpenId(code: obj.code!)
            }else{
                HCShowError(info: "授权失败")
            }
        }else if resp.isKind(of: SendMessageToWXResp.self){
            if resp.errCode == 0{
                //分享成功
                showAlert(title: "分享成功", message: "")
            }else{
                showAlert(title: "分享不成功", message: "")
            }
        }
        
    }
    
    func onReq(_ req: BaseReq!) {
        //
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        HttpRequestManager.shareIntance.HC_getUpdateLock(callback: {(isOn)in
            if isOn == true{
                HCPrint(message: "打开版本检测")
                HttpClient.shareIntance.CheckVersion()
            }else{
                HCPrint(message: "关闭版本检测")
            }
        })
        
        NetworkStatusTool.NetworkingStatus()
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate : UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        HCPrint(message: "didRegister ***** notificationSetting")
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        UMessage.registerDeviceToken(deviceToken)
        
        let data = deviceToken as NSData
        let token = data.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        HCPrint(message: token)

        let infoDic = Bundle.main.infoDictionary
        let vers = infoDic?["CFBundleShortVersionString"]
        
        let infoD = ["registerId": token, "version" : vers]
        HttpRequestManager.shareIntance.updateinfo(infoDic: infoD as NSDictionary) { (success, message) in
            if success == false {
                HCPrint(message: "上传token失败！")
            }else{
                HCPrint(message: "上传token成功！")
            }
        }
    }

    //收到远程推送消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.didReceiveRemoteNotification(userInfo)
        self.receiveRemoteNotificationForbackground(userInfo: userInfo)
        HCPrint(message: userInfo)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let information = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
            HCPrint(message: information)
        }else{
            //应用处于后台时的本地推送接受
        }
    }


    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let information = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
            HCPrint(message: information)
        }else{
            //应用处于前台时的本地推送接受
        }
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    
    func receiveRemoteNotificationForbackground(userInfo : [AnyHashable : Any]){
        
        let alertController = UIAlertController(title: "提示信息",
                                                message: "您有一条最新消息！", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "马上查看", style: .default, handler: {(action)->() in
            
            let tempId = userInfo["patientId"] as! String
            let scanner = Scanner(string: tempId)
            var patientId : Int64 = 0
            scanner.scanInt64(&patientId)
            let id = NSNumber.init(value: patientId)
            
            let tempDocId = userInfo["doctorId"] as! String
            let scannerForD = Scanner(string: tempDocId)
            var docId : Int64 = 0
            scannerForD.scanInt64(&docId)
            let doctorId = NSNumber.init(value: docId)

            let tabVC = self.window?.rootViewController as! MainTabBarController
            let selVC = tabVC.selectedViewController as! UINavigationController
            let currentVC = selVC.visibleViewController
            if (currentVC?.isKind(of: TestViewController.classForCoder()))!{
                let consultVC = currentVC as! TestViewController
                if consultVC.patientId == id{
                    consultVC.requestData()
                }else{
                    let testVC = TestViewController()
                    testVC.patientId = id
                    testVC.doctorId = doctorId
                    selVC.pushViewController(testVC, animated: true)
                }
            }else{
                let testVC = TestViewController()
                testVC.patientId = id
                testVC.doctorId = doctorId
                selVC.pushViewController(testVC, animated: true)
            }
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

}


