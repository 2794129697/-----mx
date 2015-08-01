
//  AppDelegate.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/29.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
var tencentkAppKey = ""
var weibokAppKey = "2516814566"
var weibSecret = "860051ae2ceefa4034902dfd681a8b8f"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WeiboSDKDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //监测设备网络变化
        NetWorkHelper.registerNetWorkMonitor()
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.backgroundColor = UIColor.blueColor()
//        self.window?.makeKeyAndVisible()
        WeiboSDK.enableDebugMode(true);
        WeiboSDK.registerApp(weibokAppKey);
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var result = false
        if LoginTool.loginType == .QQ {
            result = TencentOAuth.HandleOpenURL(url)
        }else if LoginTool.loginType == .Sina {
            result = WeiboSDK.handleOpenURL(url, delegate:self)
        }
        return result
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        var result = false
        if LoginTool.loginType == .QQ {
            result = TencentOAuth.HandleOpenURL(url)
        }else if LoginTool.loginType == .Sina {
            result = WeiboSDK.handleOpenURL(url, delegate:self)
        }
        return result
    }
    
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        if (response.isKindOfClass(WBSendMessageToWeiboResponse)) {
            var message = "响应状态:\(response.statusCode.rawValue)\n响应UserInfo数据:\(response.userInfo)\n原请求UserInfo数据:\(response.requestUserInfo)"
            var alert = UIAlertView(title: "发送结果", message: message, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        } else if (response.isKindOfClass(WBAuthorizeResponse)) {
            var message = "响应状态: \(response.statusCode.rawValue)\nresponse.userId: \((response as! WBAuthorizeResponse).userID)\nresponse.accessToken: \((response as! WBAuthorizeResponse).accessToken)\n响应UserInfo数据: \(response.userInfo)\n原请求UserInfo数据: \(response.requestUserInfo)"
            var alert = UIAlertView(title: "认证结果", message: message, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
}

